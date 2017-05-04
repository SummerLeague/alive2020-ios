//
//  AVPlayerView.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/25/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    override class var layerClass: Swift.AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}
