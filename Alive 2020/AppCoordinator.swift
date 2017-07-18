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
        return PreviewController(delegate: self)
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

extension AppCoordinator: PreviewControllerDelegate {
    func submitted() {
        guard let composition = livePhotoController.composition(),
            let exporter = AVAssetExportSession(
                asset: composition.composition,
                presetName: AVAssetExportPresetHighestQuality) else {
                    return
        }
       
        let videoComposition = AVMutableVideoComposition(
            clips: composition.clips,
            size: CGSize(width: 1440.0, height: 1080.0),
            crop: .portrait)
        let url = temporaryUrl(extension: "mp4")
        
        exporter.outputFileType = AVFileTypeMPEG4
        exporter.outputURL = url
        exporter.videoComposition = videoComposition
        exporter.exportAsynchronously {
            print("done \(exporter.status) \(exporter.error)")
            guard exporter.status == .completed else { return }
            print("done: \(url)")
            
            let library = ALAssetsLibrary()
            library.writeVideoAtPath(
                toSavedPhotosAlbum: url,
                completionBlock: { (url, error) in
                    print("\(url), \(error)")
            })
        }
    }
}
