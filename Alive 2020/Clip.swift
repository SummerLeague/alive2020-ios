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

extension Clip {
    func crop() -> Crop {
        let isLandscape = preferredTransform.degrees() == 0.0
        return isLandscape ? Crop.landscape : Crop.portrait
    }
    
    func croppedSize() -> CGSize {
        return crop().croppedSize(naturalSize)
    }
    
    func scale(crop targetCrop: Crop) -> CGPoint {
        let sourceSize = croppedSize()
        let targetSize = targetCrop.croppedSize(videoTrack.naturalSize)
       
        let scale = targetCrop == .landscape
            ? (targetSize.height / sourceSize.height)
            : (targetSize.width / sourceSize.width)

        return CGPoint(x: scale, y: scale)
    }
}

extension AVMutableVideoCompositionLayerInstruction {
    convenience init(clip: Clip, size: CGSize, crop: Crop) {
        self.init(assetTrack: clip.videoTrack)
        let scale = clip.scale(crop: crop)
        let clipSize = CGSize(
            width: clip.naturalSize.width * scale.x,
            height: clip.naturalSize.height * scale.y)
        let xformScale = CGAffineTransform(scaleX: scale.x, y: scale.y)
        let xformModel = CGAffineTransform(translationX: clipSize.width * -0.5, y: clipSize.height * -0.5)
        let xformRotation = CGAffineTransform(rotationAngle: clip.preferredTransform.rotation())
        let xformWorld = CGAffineTransform(translationX: size.width * 0.5, y: size.height * 0.5)
        let transform = xformScale
            .concatenating(xformModel)
            .concatenating(xformRotation)
            .concatenating(xformWorld)
        setTransform(transform, at: clip.timeRange.start)
    }
}

extension AVMutableVideoCompositionInstruction {
    convenience init(clip: Clip, size: CGSize, crop: Crop) {
        self.init()
        timeRange = clip.timeRange
        layerInstructions = [
            AVMutableVideoCompositionLayerInstruction(
                clip: clip,
                size: size,
                crop: crop)
        ]
    }
}

extension AVMutableVideoComposition {
    convenience init(clips: [Clip], size: CGSize, crop: Crop) {
        self.init()
        renderSize = crop.croppedSize(size)
        frameDuration = CMTimeMake(1, 30)
        instructions = clips.flatMap {
            AVMutableVideoCompositionInstruction(
                clip: $0,
                size: renderSize,
                crop: crop)
        }
    }
}
