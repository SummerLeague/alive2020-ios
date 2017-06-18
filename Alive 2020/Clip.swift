//
//  Clip.swift
//  Alive 2020
//
//  Created by Mark Stultz on 5/30/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import AVFoundation

struct Clip {
    var asset: AVURLAsset
    var timeRange: CMTimeRange
    var naturalSize: CGSize
    var preferredTransform: CGAffineTransform
    let audioTrack: AVMutableCompositionTrack
    let videoTrack: AVMutableCompositionTrack
}

extension CGFloat {
    public static var deg2rad: CGFloat { return pi / 180 }
    public static var rad2deg: CGFloat { return 180 / pi }
}

extension Clip {
    func scale() -> CGAffineTransform {
        let degrees = atan2(preferredTransform.b, preferredTransform.a) * CGFloat.rad2deg

        if degrees == 0 {
            return CGAffineTransform(
                scaleX: naturalSize.width / videoTrack.naturalSize.width,
                y: naturalSize.height / videoTrack.naturalSize.height)
        } else {
            return CGAffineTransform(
                scaleX: videoTrack.naturalSize.width / naturalSize.width,
                y: videoTrack.naturalSize.height / naturalSize.height)
        }
    }
    
    func layerInstruction() -> AVMutableVideoCompositionLayerInstruction {
        let transform = scale().concatenating(preferredTransform)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: self.videoTrack)
        layerInstruction.setTransform(transform, at: self.timeRange.start)
        return layerInstruction
    }
    
    func instruction() -> AVMutableVideoCompositionInstruction {
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = self.timeRange
        instruction.layerInstructions = [layerInstruction()]
        
        return instruction
    }
}   
