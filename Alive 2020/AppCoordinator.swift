//
//  AppCoordinator.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import AssetsLibrary

class AppCoordinator: NSObject {
    private let navigationController: UINavigationController
    
    fileprivate lazy var livePhotoController: LivePhotoController = {
        return LivePhotoController(delegate: self)
    }()
    
    fileprivate lazy var previewController: PreviewController = {
        return PreviewController(
            compositionExportProvider: self.livePhotoController)
    }()
    
    fileprivate lazy var viewController: MainViewController = {
        return MainViewController(
            contentViewController: self.livePhotoController.viewController,
            overlayViewController: self.previewController.viewController)
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension AppCoordinator: LivePhotoControllerDelegate {
    func selectedIndexPaths(_ indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            viewController.hideOverlay()
            return
        }
        
        if indexPaths.count > 0 {
            viewController.showOverlay()
        } else {
            viewController.hideOverlay()
        }
    }
}
