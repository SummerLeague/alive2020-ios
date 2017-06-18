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

class AppCoordinator: NSObject {
    private let navigationController: UINavigationController
    private let viewController = UIViewController()
    private var timelineConstraint: Constraint? = nil
    
    fileprivate let livePhotoManager = LivePhotoManager()
    fileprivate var activeIndexPath: IndexPath? = nil
    fileprivate var selectedIndexPaths = [IndexPath]()
    
    fileprivate lazy var livePhotoViewController: LivePhotoViewController = {
        let viewController = LivePhotoViewController()
        viewController.delegate = self
        viewController.dataSource = self.livePhotoManager
        
        // So we can present playback over live photos but under timeline
        viewController.definesPresentationContext = true
        
        return viewController
    }()
    
    private lazy var timelineViewController: TimelineViewController = {
        let viewController = TimelineViewController()
        viewController.delegate = self
        return viewController
    }()
    
    fileprivate var playbackViewController: PlaybackViewController? = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        addChildViewController(livePhotoViewController, to: viewController)
        addChildViewController(timelineViewController, to: viewController)
       
        livePhotoViewController.view.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(viewController.view)
        }
        
        timelineViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(viewController.view)
            make.height.equalTo(60.0)
            self.timelineConstraint = make.bottom.equalTo(viewController.view).offset(60.0).constraint
        }
        
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    fileprivate func showTimeline() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
            self.timelineConstraint?.update(offset: 0.0)
            self.viewController.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func hideTimeline() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
            self.timelineConstraint?.update(offset: 60.0)
            self.viewController.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func reset(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        let collectionView = self.livePhotoViewController.collectionView
        let cell = collectionView.cellForItem(at: indexPath) as? VideoCell
        
        cell?.stop()
    }
    
    fileprivate func play(at indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        
        print("play \(indexPath.item)")
       
        livePhotoManager.cancelAllRequests()
        livePhotoManager.video(at: indexPath) { (asset) in
            guard let asset = asset else { return }
           
            asset.loadValuesAsynchronously(
                forKeys: ["playable"],
                completionHandler: {
                    guard asset.isPlayable else { return }
                    let item = AVPlayerItem(asset: asset)
                    
                    DispatchQueue.main.async {
                        let collectionView = self.livePhotoViewController.collectionView
                        let cell = collectionView.cellForItem(at: indexPath) as? VideoCell
                        cell?.play(item: item)
                    }
            })
        }
    }
}

extension AppCoordinator: LivePhotoViewControllerDelegate {
    func play(indexPath: IndexPath?) {
        guard indexPath != self.activeIndexPath else { return }
        
        self.reset(at: self.activeIndexPath)
        self.activeIndexPath = indexPath
        self.play(at: indexPath)
    }
    
    func select(indexPath: IndexPath) {
        let wasVisible = !selectedIndexPaths.isEmpty
        
        if !selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.append(indexPath)
            
            if !wasVisible {
                showTimeline()
            }
        }
        
        print(selectedIndexPaths)
    }
    
    func deselect(indexPath: IndexPath) {
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            
            let isVisible = !selectedIndexPaths.isEmpty
            
            if !isVisible {
                hideTimeline()
            }
        }
        
        print(selectedIndexPaths)
    }
}

extension AppCoordinator: TimelineViewControllerDelegate {
    func submitTimeline() {
        if let _ = playbackViewController {
            livePhotoViewController.dismiss(animated: true, completion: {
                self.playbackViewController = nil
            })
        } else {
            let group = DispatchGroup()
            var assets = [AVURLAsset]()
            
            for indexPath in selectedIndexPaths {
                group.enter()
               
                livePhotoManager.video(at: indexPath, completion: { asset in
                    if let asset = asset {
                        assets.append(asset)
                    }
                    
                    group.leave()
                })
            }
            
            group.wait()
          
            let composition = Composition()
            
            for asset in assets {
                composition.add(asset: asset)
            }
            
            let playerItem = AVPlayerItem(asset: composition.composition)
            playerItem.videoComposition = composition.videoComposition
            
            let viewController = PlaybackViewController()
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.player.replaceCurrentItem(with: playerItem)
           
            livePhotoViewController.present(viewController, animated: true, completion: nil)
            
            playbackViewController = viewController
        }
    }
}

func addChildViewController(_ child: UIViewController, to parent: UIViewController) {
    parent.addChildViewController(child)
    parent.view.addSubview(child.view)
    child.didMove(toParentViewController: parent)
}
