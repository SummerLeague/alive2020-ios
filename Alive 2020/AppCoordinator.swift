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
    
    enum State {
        case selecting
        case uploading
    }
    
    private var state: State = .selecting {
        didSet {
            switch state {
            case .selecting:
//                self.photosController.view.isUserInteractionEnabled = true
                self.uploadController.showUploadButton()
            case .uploading:
//                self.photosController.view.isUserInteractionEnabled = false
                self.uploadController.hideUploadButton()
            }
        }
    }
    
    private lazy var selectionCoordinator: SelectionCoordinator = {
        let coordinator = SelectionCoordinator(
            container: self.uploadController,
            containerView: self.uploadController.contentView)
        return coordinator
    }()
    
    private lazy var uploadController: UploadController = {
        let uploadController = UploadController()
        uploadController.onUpload = {
            guard self.state == .selecting else { return }
            
            self.state = .uploading
        }
        
        return uploadController
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
        selectionCoordinator.start()
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
