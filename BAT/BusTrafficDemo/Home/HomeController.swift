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
        
        checkInternetConnections()
        checkIfUserIsLoggedIn()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitle()
    }
    
    @objc func showSettings() {
        let settingsController = SettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.colorBar()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger-menu-icon"), style: .plain, target: self, action: #selector(showSettings))
        
        view.addSubview(findNearestBusStationsButton)
        view.addSubview(showTimetableButton)
        setupFindNearestBusStationsButton()
        setupShowTimetableButton()
    }
    
    private func checkIfUserIsLoggedIn() {
        if userManager.isUserLoggedIn() {
            return
        }
        showLoginScreen()
    }
    
    func checkInternetConnections() {
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
    
    lazy var findNearestBusStationsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.setTitle("Find nearest bus stations", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(findNearestBusStations), for: .touchUpInside)
        
        return button
    }()
    
    @objc func findNearestBusStations() {
        self.navigationController?.pushViewController(StationsARKitController(), animated: true)
    }
    
    func setupFindNearestBusStationsButton() {
        findNearestBusStationsButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
    lazy var showTimetableButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.setTitle("Show bus timetable", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showTimetable), for: .touchUpInside)
        
        return button
    }()
    
    @objc func showTimetable() {
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "timetableARKitController")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func setupShowTimetableButton() {
        showTimetableButton.snp.makeConstraints { (make) in
            make.top.equalTo(findNearestBusStationsButton.snp.bottom).offset(30)
            make.left.equalTo(findNearestBusStationsButton.snp.left)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
}
