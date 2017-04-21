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
   
    private lazy var uploadController: UploadController = {
        let uploadController = UploadController()
        return uploadController
    }()
    
    private lazy var photosController: LivePhotoController = {
        let viewController = LivePhotoController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.collectionView.dataSource = self.livePhotoDataSource
        viewController.onSelected = { (indexPaths) in
            
        }
        return viewController
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        uploadController.addChildViewController(photosController)
        uploadController.contentView.addSubview(photosController.view)
        uploadController.contentView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .top, relatedBy: .equal, toItem: uploadController.contentView, attribute: .top, multiplier: 1.0, constant: 0.0))
        uploadController.contentView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .bottom, relatedBy: .equal, toItem: uploadController.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        uploadController.contentView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .leading, relatedBy: .equal, toItem: uploadController.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        uploadController.contentView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .trailing, relatedBy: .equal, toItem: uploadController.contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        photosController.didMove(toParentViewController: uploadController)
        
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([uploadController], animated: false)
    }
}
