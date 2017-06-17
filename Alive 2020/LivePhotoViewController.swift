//
//  LivePhotoViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol LivePhotoDataSource: NSObjectProtocol {
    var assetCount: Int { get }
    func thumbnail(at indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) -> PHImageRequestID
}

protocol LivePhotoViewControllerDelegate: NSObjectProtocol {
    func play(indexPath: IndexPath?)
    func select(indexPath: IndexPath)
    func deselect(indexPath: IndexPath)
}

class LivePhotoViewController: UIViewController {

    public weak var delegate: LivePhotoViewControllerDelegate? = nil
    public weak var dataSource: LivePhotoDataSource? = nil
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        view.allowsMultipleSelection = true
        view.register(VideoCell.self, forCellWithReuseIdentifier: "cell")
        
        return view
    }()
    
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
}

extension LivePhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.assetCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        let _ = dataSource?.thumbnail(at: indexPath) { (image) in
            let videoCell = cell as? VideoCell
            videoCell?.imageView.image = image
        }
        return cell
    }
}

extension LivePhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items: CGFloat = 1
        let margins: CGFloat = max(0, items - 1)
        let width = (collectionView.bounds.width - margins) / items
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.select(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.deselect(indexPath: indexPath)
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerY = scrollView.bounds.midY
        let point = CGPoint(x: 0.0, y: centerY)
        let activeIndexPath = collectionView.indexPathForItem(at: point)
       
        delegate?.play(indexPath: activeIndexPath)
    }
}
