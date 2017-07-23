//
//  LoginViewController.swift
//  Alive 2020
//
//  Created by Mark Stultz on 7/23/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    public var login: ((String, String) -> ())? = nil
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Alive 2020"
        label.font = UIFont.boldSystemFont(ofSize: 32.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        button.layer.cornerRadius = 20.0
        button.backgroundColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
       
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view).multipliedBy(0.25)
            make.leading.trailing.equalTo(view)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(16.0)
            make.trailing.equalTo(view).offset(-16.0)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(16.0)
            make.leading.equalTo(view).offset(16.0)
            make.trailing.equalTo(view).offset(-16.0)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.centerY).offset(20.0)
            make.centerX.equalTo(view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(32.0)
            make.height.equalTo(40.0)
            make.width.equalTo(120.0)
        }
    
        usernameTextField.becomeFirstResponder()
    }
    
    @objc private func onLogin() {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        login?(username, password)
    }
}
