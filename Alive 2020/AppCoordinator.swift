//
//  AppCoordinator.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import Photos

class AppCoordinator: NSObject {
    private let navigationController: UINavigationController
    private let service = Service()
    private var isLoggingIn = false
    
    fileprivate lazy var livePhotoController: LivePhotoController = {
        return LivePhotoController(delegate: self)
    }()
    
    fileprivate lazy var loginViewController: LoginViewController = {
        let viewController = LoginViewController()
        viewController.login = self.login
        return viewController
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
        navigationController.isNavigationBarHidden = true
        
        if let user = Defaults.sharedInstance.user {
            service.authorization = user.authToken
            showLivePhotos()
        } else {
            navigationController.setViewControllers(
                [loginViewController], animated: false)
        }
    }
    
    public func showLivePhotos() {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ status in
                DispatchQueue.main.async {
                    self.showLivePhotos()
                }
            })
        } else {
            self.navigationController.setViewControllers(
                [self.viewController], animated: true)
        }
    }
    
    private func login(username: String, password: String) {
        guard !isLoggingIn else { return }
        isLoggingIn = true
        service.login(
            username: username,
            password: password) { [weak self] user in
                self?.isLoggingIn = false
                if let user = user {
                    self?.authenticate(user: user)
                } else {
                    print("Couldn't login.")
                }
        }
    }
    
    private func authenticate(user: User) {
        DispatchQueue.main.async {
            Defaults.sharedInstance.user = user
            self.service.authorization = user.authToken
            self.showLivePhotos()
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
