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

struct CompositionExport {
    let composition: AVComposition
    let videoComposition: AVVideoComposition
}

protocol CompositionExportProvider {
    func compositionExport() -> CompositionExport?
}

class LivePhotoController: NSObject {
    fileprivate lazy var delegate: LivePhotoControllerDelegate? = nil
    fileprivate let livePhotoStore = LivePhotoStore()
    fileprivate let players: [AVPlayer]
    fileprivate var activePlayers = [IndexPath: AVPlayer]()
    fileprivate var selectedIndexPaths = [IndexPath]()
    
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

extension LivePhotoController: CompositionExportProvider {
    func compositionExport() -> CompositionExport? {
        let group = DispatchGroup()
        var assets = [IndexPath: AVURLAsset]()
        
        for indexPath in selectedIndexPaths {
            group.enter()
            self.livePhotoStore.video(at: indexPath.item, completion: { asset in
                if let asset = asset {
                    assets[indexPath] = asset
                }
                group.leave()
            })
        }
        
        group.wait()
      
        let composition = Composition()
        
        selectedIndexPaths.flatMap({assets[$0]}).forEach {
            composition.add(asset: $0)
        }
        
        return CompositionExport(
            composition: composition.composition,
            videoComposition: AVMutableVideoComposition(
                clips: composition.clips,
                size: CGSize(width: 1440.0, height: 1080.0),
                crop: .portrait))
    }
}

extension LivePhotoController: LivePhotoViewControllerDelegate {
    func count(section: Int) -> Int {
        return livePhotoStore.assets.count
    }
    
    func configure(cell: LivePhotoCell, indexPath: IndexPath) {
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
        if selectedIndexPaths.index(of: indexPath) == nil {
            selectedIndexPaths.append(indexPath)
        }
        delegate?.selectedIndexPaths(selectedIndexPaths)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
        }
        delegate?.selectedIndexPaths(selectedIndexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? LivePhotoCell else { return }
        
        livePhotoStore.livePhoto(at: indexPath.item) { livePhoto in
            guard collectionView.cellForItem(at: indexPath) == cell else {
                return
            }
            cell.imageView.livePhoto = livePhoto
            cell.imageView.startPlayback(with: .hint)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        livePhotoStore.cancelLivePhoto(at: indexPath.item)
    }
}
