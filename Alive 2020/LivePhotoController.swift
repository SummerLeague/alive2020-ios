//
//  LivePhotoController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

let kMaxAVPlayers = 3

protocol LivePhotoControllerDelegate {
    func selectedIndexPaths(_ indexPaths: [IndexPath]?)
}

class LivePhotoController: NSObject {
    fileprivate lazy var delegate: LivePhotoControllerDelegate? = nil
    fileprivate let livePhotoStore = LivePhotoStore()
    fileprivate let players: [AVPlayer]
    fileprivate var activePlayers = [IndexPath: AVPlayer]()
    
    public lazy var viewController: LivePhotoViewController = {
        let viewController = LivePhotoViewController()
        viewController.delegate = self
        viewController.collectionView.delegate = self
        return viewController
    }()
    
    init(delegate: LivePhotoControllerDelegate) {
        var players = [AVPlayer]()
        for _ in 1...kMaxAVPlayers {
            players.append(AVPlayer())
        }
        
        self.players = players
        
        super.init()
        
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onPlayerReachedEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    func composition() -> Composition? {
        guard let selectedIndexPaths = viewController.collectionView.indexPathsForSelectedItems else {
            return nil
        }
        
        let group = DispatchGroup()
        var assets = [AVURLAsset]()
        
        for indexPath in selectedIndexPaths {
            group.enter()
            self.livePhotoStore.video(at: indexPath.item, completion: { asset in
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
        
        return composition
    }
    
    fileprivate func availablePlayer() -> AVPlayer? {
        return players.flatMap({
            activePlayers.values.contains($0) ? nil : $0
        }).first
    }
    
    @objc private func onPlayerReachedEnd(notification: Notification) {
        guard let item = notification.object as? AVPlayerItem,
            let player = activePlayers.values.first(
                where: {$0.currentItem == item}) else {
                    return
        }
        
        player.seek(to: kCMTimeZero)
        player.play()
    }
}

extension LivePhotoController: LivePhotoViewControllerDelegate {
    func count(section: Int) -> Int {
        return livePhotoStore.assets.count
    }
    
    func configure(cell: VideoCell, indexPath: IndexPath) {
        /**/
    }
}

extension LivePhotoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items: CGFloat = 1
        let margins: CGFloat = max(0, items - 1)
        let width = (collectionView.bounds.width - margins) / items
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select \(indexPath)")
        delegate?.selectedIndexPaths(collectionView.indexPathsForSelectedItems)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselect \(indexPath)")
        delegate?.selectedIndexPaths(collectionView.indexPathsForSelectedItems)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VideoCell else { return }
        
        livePhotoStore.thumbnail(at: indexPath.item) { image in
            guard collectionView.cellForItem(at: indexPath) == cell else {
                return
            }
            cell.imageView.image = image
        }
        
        livePhotoStore.video(at: indexPath.item) { asset in
            guard let asset = asset,
                collectionView.cellForItem(at: indexPath) == cell else {
                return
            }
            
            asset.loadValuesAsynchronously(
                forKeys: ["playable"],
                completionHandler: {
                    guard asset.isPlayable else { return }
                    let item = AVPlayerItem(asset: asset)
                    
                    DispatchQueue.main.async {
                        guard let player = self.availablePlayer(),
                            collectionView.cellForItem(
                                at: indexPath) == cell else {
                                    return
                        }
                        
                        self.activePlayers[indexPath] = player
                        
                        cell.playerView.player = player
                        
                        let start = CFAbsoluteTimeGetCurrent()
                        player.replaceCurrentItem(with: item)
                        print(CFAbsoluteTimeGetCurrent() - start)
                        player.play()
                        
                        UIView.animate(
                            withDuration: 0.2,
                            delay: 0.4,
                            options: UIViewAnimationOptions(rawValue: 0),
                            animations: {
                                cell.imageView.alpha = 0.0
                            }, completion: nil)
                    }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        livePhotoStore.cancelThumbnail(at: indexPath.item)
        livePhotoStore.cancelVideo(at: indexPath.item)
        activePlayers.removeValue(forKey: indexPath)
        
//    func stop() {
//        player?.pause()
//        
//        if let item = player?.currentItem {
//            print("pause: \(item.asset)")
//        } else {
//            print("pause()")
//        }
//        
//        player?.replaceCurrentItem(with: nil)
//        player = nil
//        
//        UIView.animate(
//            withDuration: 0.2,
//            delay: 0.0,
//            options: UIViewAnimationOptions(rawValue: 0),
//            animations: {
//                self.imageView.alpha = 1.0
//            }, completion: nil)
//    }
//
    }
}
