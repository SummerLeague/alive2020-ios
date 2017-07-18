//
//  MainViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private let contentViewController: UIViewController
    private let overlayViewController: UIViewController
    private var overlayConstraint: Constraint? = nil
    
    init(contentViewController: UIViewController, overlayViewController: UIViewController) {
        self.contentViewController = contentViewController
        self.contentViewController.definesPresentationContext = true
        self.overlayViewController = overlayViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contain(viewController: contentViewController)
        contain(viewController: overlayViewController)
        
        contentViewController.view.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.view)
        }
        
        overlayViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(60.0)
            self.overlayConstraint = make.bottom.equalTo(self.view).offset(60.0).constraint
        }
    }
    
    public func showOverlay() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
            self.overlayConstraint?.update(offset: 0.0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func hideOverlay() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
            self.overlayConstraint?.update(offset: 60.0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
