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
        //updateTitle()
    }
    
    @objc func showSettings() {
        let settingsController = SettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.colorBar()
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger-menu-icon"), style: .plain, target: self, action: #selector(showSettings))
        navigationItem.title = "Home"
        
        
        view.addSubview(backgroundPic)
        view.addSubview(findNearestBusStationsButton)
        view.addSubview(showTimetableButton)
        setupFindNearestBusStationsButton()
        setupShowTimetableButton()
        setupPic()
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
        //button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.setTitle("Bus Stations", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 1.0, alpha: 1).cgColor
        button.addTarget(self, action: #selector(findNearestBusStations), for: .touchUpInside)
        
        return button
    }()
    
    @objc func findNearestBusStations() {
        self.navigationController?.pushViewController(StationsARKitController(), animated: true)
    }
    
    func setupFindNearestBusStationsButton() {
        findNearestBusStationsButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(view.frame.width / 2 - 7)
            make.height.equalTo(150)
        }
    }
    
    lazy var showTimetableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Timetable", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(white: 1.0, alpha: 1).cgColor
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
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(view.frame.width / 2 - 7)
            make.height.equalTo(150)
        }
    }
    
    lazy var backgroundPic: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "busPic")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    func setupPic() {
        backgroundPic.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
}
