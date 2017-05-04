//
//  LivePhotoController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import AVFoundation

class LivePhotoController: UIViewController {
  
    var onActiveIndexPath: ((IndexPath?) -> ())? = nil
    var onSelection: (([IndexPath]) -> ())? = nil
    
    fileprivate var selectedIndexPaths = [IndexPath]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 0.0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.allowsMultipleSelection = true
        view.register(VideoCell.self, forCellWithReuseIdentifier: "cell")
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor.black
        view.addSubview(collectionView)

        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension LivePhotoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let items: CGFloat = 1
        let margins: CGFloat = max(0, items - 1)
        let width = (collectionView.bounds.width - margins) / items
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let livePhotoCell = cell as? LivePhotoCell
//        let isSelected = selectedIndexPaths.contains(indexPath)
//        livePhotoCell?.selectionView.setIsVisible(isSelected, animated: false)
//
//        if let index = selectedIndexPaths.index(of: indexPath) {
//            livePhotoCell?.selectionView.label.text = "\(index + 1)"
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedIndexPaths.append(indexPath)
//        onSelection?(selectedIndexPaths)
//        
//        let cell = collectionView.cellForItem(at: indexPath) as? LivePhotoCell
//        cell?.selectionView.setIsVisible(true, animated: true)
//        cell?.selectionView.label.text = "\(selectedIndexPaths.count)"
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let index = selectedIndexPaths.index(of: indexPath) {
//            selectedIndexPaths.remove(at: index)
//            onSelection?(selectedIndexPaths)
//        }
//        
//        let cell = collectionView.cellForItem(at: indexPath) as? LivePhotoCell
//        cell?.selectionView.setIsVisible(false, animated: true)
//        
//        for (index, indexPath) in selectedIndexPaths.enumerated() {
//            let cell = collectionView.cellForItem(at: indexPath) as? LivePhotoCell
//            cell?.selectionView.label.text = "\(index + 1)"
//        }
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerY = scrollView.bounds.midY
        let point = CGPoint(x: 0.0, y: centerY)
        let activeIndexPath = collectionView.indexPathForItem(at: point)
        
        onActiveIndexPath?(activeIndexPath)
    }
}
