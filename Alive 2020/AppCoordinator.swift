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
    
    enum State {
        case selecting
        case uploading
    }
    
    private var state: State = .selecting {
        didSet {
            switch state {
            case .selecting:
                self.photosController.view.isUserInteractionEnabled = true
                self.uploadController.showUploadButton()
            case .uploading:
                self.photosController.view.isUserInteractionEnabled = false
                self.uploadController.hideUploadButton()
            }
        }
    }
    
    private lazy var uploadController: UploadController = {
        let uploadController = UploadController()
        uploadController.onUpload = {
            guard self.state == .selecting else { return }
            
            self.state = .uploading
        }
        
        return uploadController
    }()
    
    private lazy var photosController: LivePhotoController = {
        let viewController = LivePhotoController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.collectionView.dataSource = self.livePhotoDataSource
        viewController.onSelection = { selection in
            guard self.state == .selecting else { return }
            
            let title = "Upload \(selection.count) Live Photos"
            self.uploadController.uploadButton.setTitle(title, for: .normal)
            
            if selection.count == 0 {
                self.uploadController.hide()
            } else {
                self.uploadController.show()
            }
        }
        
        return viewController
    }()
   
    private var uploads = [UploadOperation]() {
        didSet {
            let label = "Uploading \(self.currentUploadIndex + 1) of \(self.uploads.count) Live Photos."
            self.uploadController.progressLabel.text = label
        }
    }
    
    private var currentUploadIndex: Int = 0 {
        didSet {
            let label = "Uploading \(self.currentUploadIndex + 1) of \(self.uploads.count) Live Photos."
            self.uploadController.progressLabel.text = label
        }
    }
    
    private lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
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
        
        state = .selecting
    }
    
    func upload() {
        let operation = UploadOperation(start: { (operation) in
            DispatchQueue.main.async {
                guard let index = self.uploads.index(of: operation) else {
                    return
                }
               
                self.currentUploadIndex = index
                self.uploadController.progressView.progress = 0
            }
        }) { (progress) in
            DispatchQueue.main.async {
                let percent = Float(progress.fractionCompleted)
                self.uploadController.progressView.progress = percent
            }
        }
        operation.completionBlock = {
            DispatchQueue.main.async {
                
                guard self.queue.operationCount == 0 else { return }
                
                self.uploads.removeAll()
                self.uploadController.hide()
            }
        }
       
        uploads.append(operation)
        queue.addOperation(operation)
        uploadController.show()
    }
}
