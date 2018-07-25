//
//  SplashScreenController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/20/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

class SplashScreenController: UIViewController {

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "busPic")
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(UIColor(r: 72, g: 16, b: 84), for: .normal)
        button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleGetStarted), for: .touchUpInside)

        return button
    }()
    
    @objc func handleGetStarted() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    let bigLabel: UILabel = {
        let label = UILabel()
        label.text = "BUS AR TRAFFIC"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 161/255, green: 117/255, blue: 170/255, alpha: 1)
        view.addSubview(imageView)
        view.addSubview(getStartedButton)
        view.addSubview(bigLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        getStartedButton.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        getStartedButton.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
        getStartedButton.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        getStartedButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        bigLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        bigLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -65).isActive = true
        bigLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: -105).isActive = true
        bigLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}


