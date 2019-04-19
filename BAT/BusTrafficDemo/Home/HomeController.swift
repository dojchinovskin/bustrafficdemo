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
import CoreLocation

class HomeController: UIViewController, CLLocationManagerDelegate {
    private let backgroundPic = UIImageView()
    private let busStationsButton = UIButton(type: .custom)
    private let showTimetableButton = UIButton(type: .custom)
    
    private let userManager: UserManager = MainAssembly().getUserManager()
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        checkInternetConnections()
        checkIfUserIsLoggedIn()
        userLocation()
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.colorBar()
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger-menu-icon"), style: .plain, target: self, action: #selector(showSettings))
        navigationItem.title = "Home"
        
        var buttons: [UIButton] = []
        buttons.append(busStationsButton)
        buttons.append(showTimetableButton)
        
        for button in buttons {
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            button.backgroundColor = UIColor.clear
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor(white: 1.0, alpha: 1).cgColor
        }
        
        busStationsButton.setTitle("Bus Stations", for: .normal)
        busStationsButton.addTarget(self, action: #selector(findNearestBusStations), for: .touchUpInside)
        
        showTimetableButton.setTitle("Timetable", for: .normal)
        showTimetableButton.addTarget(self, action: #selector(showTimetable), for: .touchUpInside)
        
        backgroundPic.image = UIImage(named: "busPic")
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundPic)
        view.addSubview(busStationsButton)
        view.addSubview(showTimetableButton)
    }
    
    
    private func setupConstraints() {
        backgroundPic.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        busStationsButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(view.frame.width / 2 - 7)
            make.height.equalTo(150)
        }
        
        showTimetableButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(view.frame.width / 2 - 7)
            make.height.equalTo(150)
        }
    }
        
    private func userLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
   private func checkIfUserIsLoggedIn() {
        if !userManager.isUserLoggedIn() {
            showLoginScreen()
        }
    }
    
    private func checkInternetConnections() {
        if !Reachability.isConnectedToNetwork() {
            let noNetAlert = UIAlertController(title: "No Internet Connection", message: "Connect your phone to internet connections before using this app.", preferredStyle: .alert)
            noNetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                exit(1)
            }))
            present(noNetAlert, animated: true, completion: nil)
        }
    }

    private func showLoginScreen() {
        navigator.setLoginScreenAsRootController()
    }
    
    @objc func findNearestBusStations() {
        self.navigationController?.pushViewController(StationsARKitController(), animated: true)
    }
    
    @objc func showTimetable() {
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "timetableARKitController")
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @objc func showSettings() {
        let settingsController = SettingsController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
}
