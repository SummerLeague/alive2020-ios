//
//  PlaybackViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 6/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackViewController: UIViewController {
    public let player = AVPlayer()
    
    private lazy var playerView: AVPlayerView = {
        let playerView = AVPlayerView()
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerView.player = self.player
        
        return playerView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        view.addSubview(playerView)
        
        playerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPlayerReachedEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil)
        
        player.play()
    }
    
    @objc private func onPlayerReachedEnd() {
        guard let currentItem = player.currentItem else { return }
        
        if CMTimeCompare(currentItem.duration, player.currentTime()) == 0 {
            player.seek(to: kCMTimeZero)
            player.play()
        }
    }
}
