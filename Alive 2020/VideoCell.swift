//
//  VideoCell.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/25/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell {
    
    private let player = AVPlayer()
    private var looper: AVPlayerLooper? = nil
    
    lazy var playerView: AVPlayerView = {
        let playerView = AVPlayerView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerView.player = self.player
        
        return playerView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(playerView)
        addSubview(imageView)
        
        playerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        imageView.layer.opacity = 1.0
    
        player.pause()
    }
    
    func play(item: AVPlayerItem) {
//        player.pause()
        player.replaceCurrentItem(with: item)
        player.play()
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0.4,
            options: UIViewAnimationOptions(rawValue: 0),
            animations: {
                self.imageView.alpha = 0.0
            }, completion: nil)
    }
    
    func stop() {
        player.pause()

        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: UIViewAnimationOptions(rawValue: 0),
            animations: {
                self.imageView.alpha = 1.0
            }, completion: nil)
    }
}
