//
//  AppCoordinator.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject {
    private let navigationController: UINavigationController
    private let service = Service()
    
    fileprivate lazy var livePhotoController: LivePhotoController = {
        return LivePhotoController(delegate: self)
    }()
    
    fileprivate lazy var previewController: PreviewController = {
        return PreviewController(
            service: self.service,
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
    
    public func start() {
        login()
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func login() {
        service.login(
            username: kUsername,
            password: kPassword) { [weak self] user in
            if let user = user {
                self?.service.authorization = user.authToken
            } else {
                print("Couldn't login.")
            }
        }
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
