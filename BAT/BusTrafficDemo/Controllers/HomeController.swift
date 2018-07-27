//
//  ViewController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/20/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class HomeController: UIViewController {

    private let userManager: UserManager = MainAssembly().getUserManager()
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let noNetAlert = UIAlertController(title: "No Internet Connection", message: "Connect your phone to internet connections before using this app.", preferredStyle: .alert)
            noNetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                exit(1)
            }))
            present(noNetAlert, animated: true, completion: nil)
            
        }
        
        checkIfUserIsLoggedIn()
        
        self.navigationController?.navigationBar.colorBar()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger-menu-icon"), style: .plain, target: self, action: #selector(showSettings))
        
        view.addSubview(openCameraButton)
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitle()
    }
    
    @objc func showSettings() {
        let settingsController = SettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    private func checkIfUserIsLoggedIn() {
        if userManager.isUserLoggedIn() {
            return
        }
        showLoginScreen()
    }

    private func updateTitle() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }
            return
        }
        showLoginScreen()
    }

    private func showLoginScreen() {
        navigator.setLoginScreenAsRootController()
    }
    
    lazy var openCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.setTitle("Open Camera", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        
        return button
    }()
    
    @objc func showCamera() {
//        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "cameraViewController")
//        self.navigationController!.pushViewController(vc, animated: true)
        self.navigationController?.pushViewController(ARKITViewController(), animated: true)
    }
    
    func setupButton() {
        openCameraButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
}
