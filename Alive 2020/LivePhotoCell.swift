//
//  LivePhotoCell.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/18.
//  Copyright © 2018 Mark Stultz. All rights reserved.
//

import Photos
import RxSwift
import UIKit

class LivePhotoCell: UICollectionViewCell {

    var item: LivePhotoCellItem? {
        didSet {
            guard let item = self.item else { return }

            item.image
                .observeOn(MainScheduler.instance)
                .bind(to: imageView.rx.image)
                .disposed(by: disposeBag)
        }
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

