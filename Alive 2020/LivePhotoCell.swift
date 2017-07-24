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
    public var playbackEnded: ((PHLivePhotoView) -> ())? = nil
    
    public lazy var livePhotoView: PHLivePhotoView = {
        let view = PHLivePhotoView()
        view.delegate = self
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(livePhotoView)
        
        livePhotoView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        livePhotoView.stopPlayback()
        livePhotoView.livePhoto = nil
    }
}

extension LivePhotoCell: PHLivePhotoViewDelegate {
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        playbackEnded?(livePhotoView)
    }
}
