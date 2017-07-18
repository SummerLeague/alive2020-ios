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
    
    public lazy var playerView: AVPlayerView = {
        let playerView = AVPlayerView()
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerView
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
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
    }
}
