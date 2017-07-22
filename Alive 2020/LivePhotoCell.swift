//
//  LivePhotoCell.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/22/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import PhotosUI

class LivePhotoCell: UICollectionViewCell {
    
    public lazy var imageView: PHLivePhotoView = {
        let imageView = PHLivePhotoView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.stopPlayback()
        imageView.livePhoto = nil
    }
}
