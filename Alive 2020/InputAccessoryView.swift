//
//  InputAccessoryView.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/23/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {
    var frameChanged: ((CGRect) -> ())?
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        for keyPath in ["frame", "center"] {
            superview?.removeObserver(self, forKeyPath: keyPath)
            newSuperview?.addObserver(
                self,
                forKeyPath: keyPath,
                options: [],
                context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let view = object as? UIView else { return }
        guard view == superview else { return }
        
        frameChanged?(view.frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let superview = self.superview else { return }
        
        frameChanged?(superview.frame)
    }
}
