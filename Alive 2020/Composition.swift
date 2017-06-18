//
//  Composition.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/29/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import AVFoundation

class Composition {
    private var clips = [Clip]()
    public private(set) var composition = AVMutableComposition()
   
    var clipCount: Int { return clips.count }
    var videoComposition: AVVideoComposition {
        let portrait = CGSize(width: 1080.0, height: 1440.0)

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = portrait
        videoComposition.frameDuration = CMTimeMake(1, 30)
        videoComposition.instructions = self.clips.flatMap({$0.instruction()})
        
        return videoComposition
    }
   
    func clip(at indexPath: IndexPath) -> Clip? {
        guard indexPath.item < clips.count else { return nil }
        return clips[indexPath.item]
    }
   
    func add(asset: AVURLAsset) {
        print(asset.url)
        let audioTracks = asset.tracks(withMediaType: AVMediaTypeAudio)
        let videoTracks = asset.tracks(withMediaType: AVMediaTypeVideo)
        guard let assetAudioTrack = audioTracks.first else { return }
        guard let assetVideoTrack = videoTracks.first else { return }

        let audioTrack = composition.addMutableTrack(
            withMediaType: AVMediaTypeAudio,
            preferredTrackID: kCMPersistentTrackID_Invalid)
        
        let videoTrack = composition.addMutableTrack(
            withMediaType: AVMediaTypeVideo,
            preferredTrackID: kCMPersistentTrackID_Invalid)

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
