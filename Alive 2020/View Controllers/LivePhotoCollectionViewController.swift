//
//  LivePhotoCollectionViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/18.
//  Copyright © 2018 Mark Stultz. All rights reserved.
//

import Photos
import RxCocoa
import RxSwift
import SnapKit
import UIKit

let kItemsPerRow: CGFloat = 4.0

class LivePhotoCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    private let fetchResult: PHFetchResult<PHAsset>
    private let livePhotoStore: LivePhotoStoring

    private let disposeBag = DisposeBag()

    init(livePhotoStore: LivePhotoStoring, fetchResult: PHFetchResult<PHAsset>) {
        self.fetchResult = fetchResult
        self.livePhotoStore = livePhotoStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.minimumLineSpacing = 1.0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .black
        collectionView.register(LivePhotoCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(LivePhotoCell.self))
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let (
            cellItems,
            title
        ) = livePhotoCollectionViewModel(
            fetchResult: .just(fetchResult),
            livePhotoStore: .just(livePhotoStore),
            viewDidLoad: .just(())
        )

        cellItems
            .bind(to: collectionView.rx.items(
                cellIdentifier: NSStringFromClass(LivePhotoCell.self),
                cellType: LivePhotoCell.self)
            ) { item, data, cell in
                cell.backgroundColor = .yellow
                cell.item = data
            }
            .disposed(by: disposeBag)

        title
            .bind(to: rx.title)
            .disposed(by: disposeBag)

    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items = kItemsPerRow
        let margins: CGFloat = max(0, items - 1)
        let width = (collectionView.bounds.width - margins) / items

        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let asset = fetchResult[indexPath.item]
        livePhotoStore.startCachingThumbnail(forAsset: asset)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let asset = fetchResult[indexPath.item]
        livePhotoStore.stopCachingThumbnail(forAsset: asset)
    }

}
