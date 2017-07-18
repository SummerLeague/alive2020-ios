//
//  PHAsset+LivePhotos.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    func pairedVideoResource() -> PHAssetResource? {
        let resources = PHAssetResource.assetResources(for: self)
        let pairedVideos = resources.filter({$0.type == .pairedVideo})
        return pairedVideos.first
    }
    
    // Pull all live photos, sort by latest
    static func livePhotoAssets() -> [PHAsset] {
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
}
