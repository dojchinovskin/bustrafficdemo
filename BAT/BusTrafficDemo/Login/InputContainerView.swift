//
//  InputContainerView.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 155//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit

class InputContainerView: UIView {
    var nameTextfield = UITextField()
    var emailTextfield = UITextField()
    var passwordTextfield = UITextField()
    private var nameSeparator = UIView()
    private var emailSeparator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        nameTextfield.placeholder = "Name"
        emailTextfield.placeholder = "Email"
        emailTextfield.keyboardType = .emailAddress
        passwordTextfield.placeholder = "Password"
        passwordTextfield.isSecureTextEntry = true
        
        nameSeparator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        emailSeparator.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        self.addSubview(nameTextfield)
        self.addSubview(emailTextfield)
        self.addSubview(passwordTextfield)
        self.addSubview(nameSeparator)
        self.addSubview(emailSeparator)
    }
    
    private func setupConstraints() {
        nameTextfield.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0)
        }
        
        emailTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextfield.snp.left)
            make.top.equalTo(nameSeparator.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        passwordTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextfield.snp.left)
            make.top.equalTo(emailSeparator.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        nameSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextfield.snp.bottom)
            make.left.width.equalToSuperview()
            make.height.equalTo(1)
        }

        emailSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextfield.snp.bottom)
            make.left.width.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func updateConstraints(_ isNameVisible: Bool) {
        nameTextfield.snp.remakeConstraints { (remake) in
            remake.left.equalToSuperview().offset(15)
            remake.top.width.equalToSuperview()
            remake.height.equalToSuperview().multipliedBy(isNameVisible ? 0 : 0.33)
        }

        emailTextfield.snp.remakeConstraints { (remake) in
            remake.left.equalTo(nameTextfield.snp.left)
            remake.top.equalTo(nameSeparator.snp.bottom)
            remake.width.equalToSuperview()
            remake.height.equalToSuperview().multipliedBy(isNameVisible ? 0.5 : 0.33)
        }

        passwordTextfield.snp.remakeConstraints { (remake) in
            remake.left.equalTo(nameTextfield.snp.left)
            remake.top.equalTo(emailSeparator.snp.bottom)
            remake.width.equalToSuperview()
            remake.height.equalToSuperview().multipliedBy(isNameVisible ? 0.5 : 0.33)
        }
                
    }
}
