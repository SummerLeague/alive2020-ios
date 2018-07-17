//
//  PHAsset+LivePhotos.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/18.
//  Copyright © 2018 Mark Stultz. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {

    func pairedVideoResource() -> PHAssetResource? {
        let resources = PHAssetResource.assetResources(for: self)
        let pairedVideos = resources.filter({$0.type == .pairedVideo})
        return pairedVideos.first
    }

    static func fetchLivePhotos() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaSubtype == \(PHAssetMediaSubtype.photoLive.rawValue)")
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        return PHAsset.fetchAssets(with: .image, options: options)
    }

}

