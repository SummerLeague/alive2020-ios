//
//  LivePhotoCell.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import PhotosUI

class LivePhotoCell: UICollectionViewCell {
   
    lazy var livePhotoView: PHLivePhotoView = {
        let view = PHLivePhotoView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isSelectionVisible: Bool = false {
        didSet{
            if isSelectionVisible {
               self.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
            } else {
               self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 50.0
        isSelectionVisible = false
       
        addSubview(livePhotoView)
        
        addConstraint(NSLayoutConstraint(item: livePhotoView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: livePhotoView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: livePhotoView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: livePhotoView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelectionVisible = false
    }
}