//
//  UploadController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/21/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class UploadController: UIViewController {
    
    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progress = 0.33
        return view
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "Uploading 3 of 23 Live Photos..."
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        view.addSubview(blurView)
        blurView.addSubview(progressView)
        blurView.addSubview(progressLabel)
        
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        view.addConstraint(NSLayoutConstraint(item: blurView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: blurView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: blurView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: blurView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60.0))

        blurView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: blurView, attribute: .top, multiplier: 1.0, constant: 0.0))
        blurView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: blurView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        blurView.addConstraint(NSLayoutConstraint(item: progressView, attribute: .trailing, relatedBy: .equal, toItem: blurView, attribute: .trailing, multiplier: 1.0, constant: 0.0))

        blurView.addConstraint(NSLayoutConstraint(item: progressLabel, attribute: .centerY, relatedBy: .equal, toItem: blurView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        blurView.addConstraint(NSLayoutConstraint(item: progressLabel, attribute: .leading, relatedBy: .equal, toItem: blurView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        blurView.addConstraint(NSLayoutConstraint(item: progressLabel, attribute: .trailing, relatedBy: .equal, toItem: blurView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
