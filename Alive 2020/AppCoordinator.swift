//
//  AppCoordinator.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class AppCoordinator {
    private let navigationController: UINavigationController
    private let livePhotoDataSource = LivePhotoDataSource()
    
    private lazy var viewController: LivePhotoController = {
        let viewController = LivePhotoController()
        viewController.collectionView.dataSource = self.livePhotoDataSource
        
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([viewController], animated: false)
    }
}
