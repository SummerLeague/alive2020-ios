//
//  LoadOperation.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/3/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import Photos

class LoadOperation: Operation {
  
    enum State {
        case ready
        case executing
        case finished
        
        var key: String {
            switch self {
                case .ready: return "isReady"
                case .executing: return "isExecuting"
                case .finished: return "isFinished"
            }
        }
    }
    
    let asset: PHAsset
    let resourceManager: PHAssetResourceManager
    var requestId: PHAssetResourceDataRequestID? = nil
    var outputAsset: AVURLAsset? = nil
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.key)
            willChangeValue(forKey: newValue.key)
        }
        didSet {
            didChangeValue(forKey: oldValue.key)
            didChangeValue(forKey: state.key)
        }
    }
    
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return self.state == .executing }
    override var isFinished: Bool { return self.state == .finished }
    
    init(asset: PHAsset, resourceManager: PHAssetResourceManager) {
        self.asset = asset
        self.resourceManager = resourceManager
        super.init()
    }
    
    deinit {
        print("~deinit")
    }
    
    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        // get paired video for asset
        let resources = PHAssetResource.assetResources(for: asset)
        let pairedVideos = resources.filter({$0.type == .pairedVideo})
        
        guard let pairedVideo = pairedVideos.first else {
            state = .finished
            return
        }
        
        let name = "\(UUID().uuidString).mov"
        let path = "\(NSTemporaryDirectory())\(name)"
        let url = URL(fileURLWithPath: path)
        let mutableData = NSMutableData()
        
        self.requestId = resourceManager.requestData(for: pairedVideo, options: nil, dataReceivedHandler: { (data) in
            mutableData.append(data)
        }) { (error) in
            guard error == nil else {
                self.state = .finished
                return
            }
            
            mutableData.write(to: url, atomically: true)
            self.outputAsset = AVURLAsset(url: url)
            self.state = .finished
        }
    }
  
    override func cancel() {
        if let requestId = self.requestId {
            resourceManager.cancelDataRequest(requestId)
        }
        
        super.cancel()
    }
}
