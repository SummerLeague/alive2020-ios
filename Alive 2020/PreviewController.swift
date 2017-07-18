//
//  PreviewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

protocol PreviewControllerDelegate {
    func submitted()
}

class PreviewController {
    private lazy var delegate: PreviewControllerDelegate? = nil
    
    public lazy var viewController: PreviewViewController = {
        let viewController = PreviewViewController()
        viewController.onSubmit = self.onSubmit
        return viewController
    }()
    
    init(delegate: PreviewControllerDelegate) {
        self.delegate = delegate
    }
    
    func onSubmit() {
        delegate?.submitted()
    }
}
