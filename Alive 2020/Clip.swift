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
    let audioTrack: AVMutableCompositionTrack
    let videoTrack: AVMutableCompositionTrack
}

extension Clip {
    func layerInstruction() -> AVMutableVideoCompositionLayerInstruction {
        let trackSize = self.videoTrack.naturalSize
        let scaleFactor = trackSize.width / self.naturalSize.width
        let translation = CGAffineTransform(translationX: trackSize.height, y: 0.0)
        let rotation = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let transform = scale.concatenating(rotation).concatenating(translation)
        
        print("size: \(trackSize.width) x \(trackSize.height) \(self.naturalSize)")
        
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
