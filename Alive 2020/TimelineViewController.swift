//
//  TimelineViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 6/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

protocol TimelineViewControllerDelegate: NSObjectProtocol {
    func submitTimeline()
}

class TimelineViewController: UIViewController {
   
    public weak var delegate: TimelineViewControllerDelegate? = nil
    
    private lazy var button: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Pay Attention", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.trailing.equalTo(view).offset(-12.0)
        }
    }
    
    @objc func onButton(sender: Any) {
        delegate?.submitTimeline()
    }
}