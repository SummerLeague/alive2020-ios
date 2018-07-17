//
//  LivePhotoStore.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/18.
//  Copyright © 2018 Mark Stultz. All rights reserved.
//

import Foundation
import Photos
import RxSwift

protocol LivePhotoStoring {
    func thumbnail(forAsset asset: PHAsset) -> Observable<UIImage>
    func startCachingThumbnail(forAsset asset: PHAsset)
    func stopCachingThumbnail(forAsset asset: PHAsset)
}

enum LivePhotoStoreError: Error {
     case unknownError
}

class LivePhotoStore: LivePhotoStoring {

    private let imageManager = PHCachingImageManager()

    // MARK: - LivePhotoStoring

    func thumbnail(forAsset asset: PHAsset) -> Observable<UIImage> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }

            let imageManager = strongSelf.imageManager
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.resizeMode = .fast
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true

            let requestId = imageManager.requestImage(
                for: asset,
                targetSize: CGSize(width: 175.0, height: 175.0),
                contentMode: .aspectFill,
                options: options) { (image, info) in
                    if let image = image {
                        observer.onNext(image)
                    } else if let error = info?[PHImageErrorKey] as? Error {
                        observer.onError(error)
                    } else {
                        observer.onError(LivePhotoStoreError.unknownError)
                    }
            }

            return Disposables.create {
                imageManager.cancelImageRequest(requestId)
            }
        }
    }

    func startCachingThumbnail(forAsset asset: PHAsset) {
        imageManager.startCachingImages(
            for: [asset],
            targetSize: CGSize(width: 175.0, height: 175.0),
            contentMode: .aspectFill,
            options: nil)
    }

    func stopCachingThumbnail(forAsset asset: PHAsset) {
        imageManager.stopCachingImages(
            for: [asset],
            targetSize: CGSize(width: 175.0, height: 175.0),
            contentMode: .aspectFill, options: nil)
    }

}
