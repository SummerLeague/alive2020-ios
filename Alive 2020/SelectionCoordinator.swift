//
//  SelectionCoordinator.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/26/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation

class SelectionCoordinator {

    private let containerViewController: UIViewController
    private let containerView: UIView
    private let livePhotoDataSource = LivePhotoDataSource()
    
    private var activeIndexPath: IndexPath? = nil
    
    private lazy var photosController: LivePhotoController = {
        let viewController = LivePhotoController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.collectionView.dataSource = self.livePhotoDataSource
        viewController.onActiveIndexPath = { indexPath in
            guard indexPath != self.activeIndexPath else { return }
            
            self.reset(at: self.activeIndexPath)
            self.activeIndexPath = indexPath
            self.play(at: indexPath)
        }
        viewController.onSelection = { selection in
//            guard self.state == .selecting else { return }
            
            let title = "Upload \(selection.count) Live Photos"
//            self.uploadController.uploadButton.setTitle(title, for: .normal)
            
            if selection.count == 0 {
//                self.uploadController.hide()
            } else {
//                self.uploadController.show()
            }
        }
        
        return viewController
    }()
    
    init(container: UIViewController, containerView: UIView) {
        self.containerViewController = container
        self.containerView = containerView
    }
    
    func start() {
        containerViewController.addChildViewController(photosController)
        containerView.addSubview(photosController.view)
        containerView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0.0))
        containerView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        containerView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        containerView.addConstraint(NSLayoutConstraint(item: photosController.view, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        photosController.didMove(toParentViewController: containerViewController)
    }
   
    func reset(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let collectionView = self.photosController.collectionView
        let cell = collectionView.cellForItem(at: indexPath) as? VideoCell
        
        cell?.stop()
    }
    
    func play(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        print("play \(indexPath.item)")
        
        livePhotoDataSource.video(at: indexPath) { (asset) in
            guard let asset = asset else { return }
            let item = AVPlayerItem(asset: asset)
            
            DispatchQueue.main.async {
                let collectionView = self.photosController.collectionView
                let cell = collectionView.cellForItem(at: indexPath) as? VideoCell
                cell?.play(item: item)
            }
        }
    }
}
