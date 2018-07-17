//
//  LivePhotoCollectionViewModel.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/18.
//  Copyright © 2018 Mark Stultz. All rights reserved.
//

import Foundation
import Photos
import RxSwift

struct LivePhotoCellItem {
    let asset: PHAsset

    private let livePhotoStore: LivePhotoStoring

    init(livePhotoStore: LivePhotoStoring, asset: PHAsset) {
        self.livePhotoStore = livePhotoStore
        self.asset = asset
    }

    var image: Observable<UIImage> {
        return livePhotoStore.thumbnail(forAsset: asset)
    }
}

func livePhotoCollectionViewModel(
    fetchResult: Observable<PHFetchResult<PHAsset>>,
    livePhotoStore: Observable<LivePhotoStoring>,
    viewDidLoad: Observable<Void>
) -> (
    cellItems: Observable<[LivePhotoCellItem]>,
    title: Observable<String>
) {

    let cellItems = fetchResult
        .withLatestFrom(livePhotoStore) { assets, livePhotoStore in
            (0..<assets.count)
                .map { LivePhotoCellItem(livePhotoStore: livePhotoStore, asset: assets[$0]) }
        }

    let title = fetchResult.map { "\($0.count) Live Photos" }

    return (
        cellItems: cellItems,
        title: title
    )
}
