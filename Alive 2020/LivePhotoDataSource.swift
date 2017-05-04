//
//  LivePhotoDataSource.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import Photos

class LivePhotoDataSource: NSObject {
    let imageManager = PHImageManager.default()
    let cachingImageManager = PHCachingImageManager()
    let resourceManager = PHAssetResourceManager.default()
   
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    fileprivate var assets: [PHAsset] {
        willSet {
           self.cachingImageManager.stopCachingImagesForAllAssets()
        }
        didSet {
            self.cachingImageManager.startCachingImages(
                for: assets,
                targetSize: CGSize(width: 512, height: 512),
                contentMode: .aspectFit,
                options: nil)
        }
    }
    
    override init() {
        assets = fetchLivePhotos()
        super.init()
    }

    func thumbnail(at indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) -> PHImageRequestID {
        let asset = assets[indexPath.item]
        let size = CGSize(width: 512, height: 512)
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isSynchronous = false
        
        return cachingImageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options) { (image, info) in
            completion(image)
        }
    }
    
    func video(at indexPath: IndexPath, completion: @escaping (AVURLAsset?) -> ()) {
        let asset = self.assets[indexPath.item]
        let operation = LoadOperation(
            asset: asset,
            resourceManager: resourceManager)
        weak var weakOp = operation
        operation.completionBlock = {
            completion(weakOp?.outputAsset)
        }
        
        queue.cancelAllOperations()
        queue.addOperation(operation)
    }
   
    func livePhoto(at indexPath: IndexPath, completion: @escaping (PHLivePhoto?) -> ()) -> PHImageRequestID {
        let asset = assets[indexPath.item]
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .opportunistic
       
        let request = imageManager.requestLivePhoto(
            for: asset,
            targetSize: CGSize(width: 512, height: 512),
            contentMode: .aspectFit,
            options: options) { (livePhoto, info) in
               completion(livePhoto)
        }
        
        return request
    }
}

extension LivePhotoDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        let videoCell = cell as? VideoCell
        let _ = thumbnail(at: indexPath) { (image) in
            videoCell?.imageView.image = image
        }
        return cell
    }
}

// Pull all live photos, sort by latest
func fetchLivePhotos() -> [PHAsset] {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(
        format: "mediaSubtype == %ld",
        PHAssetMediaSubtype.photoLive.rawValue)
    options.sortDescriptors = [
        NSSortDescriptor(key: "creationDate", ascending: false)
    ]

    var assets = [PHAsset]()
   
    let results = PHAsset.fetchAssets(with: .image, options: options)
    results.enumerateObjects({ (asset, index, _) in
       assets.append(asset)
    })
    
    return assets
}
