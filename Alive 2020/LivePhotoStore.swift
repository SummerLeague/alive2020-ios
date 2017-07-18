//
//  LivePhotoStore.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import Photos

class LivePhotoStore: NSObject {
    private let imageManager = PHImageManager.default()
    private let cachingImageManager = PHCachingImageManager()
    private let resourceManager = PHAssetResourceManager.default()
    private let thumbnailQueue = DispatchQueue(label: "thumbnailQueue")
    private let videoQueue = DispatchQueue(label: "videoQueue")
    private var thumbnailRequests = [Int: PHImageRequestID]()
    private var videoRequests = [Int: PHAssetResourceDataRequestID]()
    public let assets = PHAsset.livePhotoAssets()
    
    override init() {
        super.init()
        cachingImageManager.startCachingImages(
            for: assets,
            targetSize: CGSize(width: 512, height: 512),
            contentMode: .aspectFit,
            options: nil)
    }
    
    public func thumbnail(at index: Int, completion: @escaping (UIImage?) -> ()) {
        let asset = assets[index]
        let size = CGSize(width: 512, height: 512)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true

        let requestId = cachingImageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options) { (image, info) in
                if let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool,
                    !isDegraded {
                    self.thumbnailQueue.async {
                        self.thumbnailRequests.removeValue(forKey: index)
                    }
                }
                
                completion(image)
        }
        
        thumbnailQueue.async {
            self.thumbnailRequests[index] = requestId
        }
    }
    
    public func cancelThumbnail(at index: Int) {
        guard let requestId = thumbnailRequests[index] else { return }
        thumbnailQueue.async {
            self.cachingImageManager.cancelImageRequest(requestId)
            self.thumbnailRequests.removeValue(forKey: index)
        }
    }
    
    public func video(at index: Int, completion: @escaping (AVURLAsset?) -> ()) {
        let asset = self.assets[index]
        
        guard let pairedVideo = asset.pairedVideoResource() else { return }
        
        let mutableData = NSMutableData()
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        
        let requestId = resourceManager.requestData(
            for: pairedVideo,
            options: options,
            dataReceivedHandler: { data in
                mutableData.append(data)
        }) { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                let url = temporaryUrl(extension: "mov")
                mutableData.write(to: url, atomically: true)
                let movie = AVURLAsset(url: url)
                completion(movie)
            }
            
            self.videoQueue.async {
                self.videoRequests.removeValue(forKey: index)
            }
        }
        
        videoQueue.async {
            self.videoRequests[index] = requestId
        }
    }
    
    public func cancelVideo(at index: Int) {
        guard let requestId = videoRequests[index] else { return }
        videoQueue.async {
            self.resourceManager.cancelDataRequest(requestId)
            self.videoRequests.removeValue(forKey: index)
        }
    }
}
