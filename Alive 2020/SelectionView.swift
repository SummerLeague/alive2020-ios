//
//  SelectionView.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/23/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class SelectionView: UIView {
    private static let kSelectionSize: CGFloat = 23.0
   
    public private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    private lazy var labelBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = view.tintColor
        view.layer.cornerRadius = kSelectionSize * 0.5
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        
        return view
    }()
    
    private lazy var overlay: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black
        overlay.layer.opacity = 0.0
        
        return overlay
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        labelBackground.addSubview(label)
        addSubview(overlay)
        addSubview(labelBackground)
        
        addConstraint(NSLayoutConstraint(item: overlay, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: overlay, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: overlay, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: overlay, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: labelBackground, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -4))
        addConstraint(NSLayoutConstraint(item: labelBackground, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -4))
        addConstraint(NSLayoutConstraint(item: labelBackground, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: SelectionView.kSelectionSize))
        addConstraint(NSLayoutConstraint(item: labelBackground, attribute: .height, relatedBy: .equal, toItem: labelBackground, attribute: .width, multiplier: 1, constant: 0))

        labelBackground.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: labelBackground, attribute: .centerY, multiplier: 1, constant: 0))
        labelBackground.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: labelBackground, attribute: .leading, multiplier: 1, constant: 4))
        labelBackground.addConstraint(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: labelBackground, attribute: .trailing, multiplier: 1, constant: -4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIsVisible(_ isVisible: Bool, animated: Bool) {
        if (animated) {
            let scale = CABasicAnimation(keyPath: "transform.scale")
            scale.fromValue = isVisible ? 0.5 : 1.0
            scale.toValue = isVisible ? 1.0 : 0.5
            
            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.fromValue = isVisible ? 0.0 : 1.0
            opacity.toValue = isVisible ? 1.0 : 0.0
            
            let group = CAAnimationGroup()
            group.animations = [scale, opacity]
            group.duration = 0.1
            group.fillMode = kCAFillModeBackwards
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            labelBackground.layer.add(group, forKey: "selection")
        }
        
        labelBackground.layer.opacity = isVisible ? 1.0 : 0.0
    }
}
