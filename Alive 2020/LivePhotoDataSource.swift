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
   
    fileprivate var assets: [PHAsset] {
        willSet {
           self.cachingImageManager.stopCachingImagesForAllAssets()
        }
        didSet(value) {
            self.cachingImageManager.startCachingImages(
                for: value,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: nil)
        }
    }
    
    override init() {
        assets = fetchLivePhotos()
        super.init()
    }
    
    func livePhoto(indexPath: IndexPath, completion: @escaping (PHLivePhoto?) -> ()) -> PHImageRequestID {
        let asset = assets[indexPath.item]
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
       
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.black
        
        if let livePhotoCell = cell as? LivePhotoCell {
            let _ = livePhoto(indexPath: indexPath, completion: { (livePhoto) in
                livePhotoCell.livePhotoView.livePhoto = livePhoto
                livePhotoCell.livePhotoView.startPlayback(with: .full)
            })
        }
        
        return cell
    }
}

// Pull all live photos, sort by latest
func fetchLivePhotos() -> [PHAsset] {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(format: "mediaSubtype == %ld", PHAssetMediaSubtype.photoLive.rawValue)
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

    var assets = [PHAsset]()
   
    let results = PHAsset.fetchAssets(with: .image, options: options)
    results.enumerateObjects({ (asset, index, _) in
       assets.append(asset)
    })
    
    return assets
}
