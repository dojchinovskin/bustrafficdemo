//
//  LoginContainerView.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 165//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit

class LoginContainerView: UIView {
    let inputContainerView = InputContainerView()
    let forgetPassButton = UIButton(type: .custom)
    let loginButton = UIButton(type: .custom)
    let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        
        loginButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        forgetPassButton.setTitle("Forget your password?", for: .normal)
        forgetPassButton.setTitleColor(.white, for: .normal)
        forgetPassButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        
        self.addSubview(loginButton)
        self.addSubview(segmentedControl)
        self.addSubview(forgetPassButton)
        self.addSubview(inputContainerView)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(inputContainerView.snp.top).offset(-15)
            make.width.equalTo(self).offset(-15)
            make.height.equalTo(36)
        }
        
        inputContainerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(100)
            make.width.equalTo(segmentedControl)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(inputContainerView.snp.bottom).offset(15)
            make.width.equalTo(inputContainerView.snp.width)
            make.height.equalTo(50)
        }
        
        forgetPassButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom)
            make.left.equalTo(inputContainerView.snp.left)
            make.height.equalTo(40)
        }
    }
}
