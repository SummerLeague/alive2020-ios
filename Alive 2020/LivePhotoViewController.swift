//
//  LivePhotoViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/16/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

protocol LivePhotoViewControllerDelegate {
    func count(section: Int) -> Int
    func configure(cell: LivePhotoCell, indexPath: IndexPath)
}

class LivePhotoViewController: UIViewController, UICollectionViewDataSource {
    public var delegate: LivePhotoViewControllerDelegate? = nil
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        let collectionView = UICollectionView(
            frame: CGRect.zero,
            collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            LivePhotoCell.self,
            forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
       
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.count(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        if let cell = cell as? LivePhotoCell {
            delegate?.configure(cell: cell, indexPath: indexPath)
        }
        return cell
    }
}
