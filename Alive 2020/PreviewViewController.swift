//
//  PreviewViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/17/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    public var onSubmit: (() -> ())? = nil
    
    private lazy var button: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Pay Attention", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        return button
    }()
    
    public private(set) lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 0.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(progressView)
        view.addSubview(button)
        
        progressView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.trailing.equalTo(view).offset(-12.0)
        }
    }
    
    @objc func onButton(sender: Any) {
        onSubmit?()
    }
}
