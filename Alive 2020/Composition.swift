//
//  Composition.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/29/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import AVFoundation

enum Crop {
    case portrait
    case landscape
    case square
}

extension Crop {
    func croppedSize(_ size: CGSize) -> CGSize {
        let minSize = min(size.width, size.height)
        let maxSize = max(size.width, size.height)
        
        switch self {
        case .portrait: return CGSize(width: minSize, height: maxSize)
        case .landscape: return CGSize(width: maxSize, height: minSize)
        case .square: return CGSize(width: minSize, height: minSize)
        }
    }
}

class Composition {
    public private(set) var clips = [Clip]()
    public let composition = AVMutableComposition()
    private let audioTracks: [AVMutableCompositionTrack]
    private let videoTracks: [AVMutableCompositionTrack]
    
    init() {
        var audioTracks = [AVMutableCompositionTrack]()
        var videoTracks = [AVMutableCompositionTrack]()
        
        for _ in 1...2 {
            audioTracks.append(
                composition.addMutableTrack(
                    withMediaType: AVMediaTypeAudio,
                    preferredTrackID: kCMPersistentTrackID_Invalid))
            
            videoTracks.append(
                composition.addMutableTrack(
                    withMediaType: AVMediaTypeVideo,
                    preferredTrackID: kCMPersistentTrackID_Invalid))
        }
        
        self.audioTracks = audioTracks
        self.videoTracks = videoTracks
    }
    
    public func add(asset: AVURLAsset) {
        guard let assetAudioTrack = asset.tracks(
            withMediaType: AVMediaTypeAudio).first,
            let assetVideoTrack = asset.tracks(
                withMediaType: AVMediaTypeVideo).first else {
                return
        }
        
        let audioTrack = self.audioTracks[clips.count % 2]
        let videoTrack = self.videoTracks[clips.count % 2]
        let srcTimeRange = CMTimeRange(start: kCMTimeZero, duration: asset.duration)
        let duration = composition.duration
        
        do {
            try audioTrack.insertTimeRange(srcTimeRange, of: assetAudioTrack, at: duration)
            try videoTrack.insertTimeRange(srcTimeRange, of: assetVideoTrack, at: duration)
        } catch let error as NSError {
            print(error)
            return
        }
        
        let timeRange = CMTimeRange(start: duration, duration: srcTimeRange.duration)
    
        let clip = Clip(
            asset: asset,
            timeRange: timeRange,
            naturalSize: assetVideoTrack.naturalSize,
            preferredTransform: assetVideoTrack.preferredTransform,
            audioTrack: audioTrack,
            videoTrack: videoTrack)
        
        clips.append(clip)
    }
}
