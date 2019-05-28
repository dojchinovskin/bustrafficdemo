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

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    private let backgroundPic = UIImageView()
    private let busStationsButton = UIButton(type: .custom)
    private let timetableButton = UIButton(type: .custom)
    private let arcardButton = UIButton(type: .custom)
    private let arweatherButton = UIButton(type: .custom)
    
    private let userManager: UserManager = MainAssembly().getUserManager()
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        checkInternetConnections()
        checkIfUserIsLoggedIn()
        getUserLocation()
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.colorBar()
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.profileMenuIcon, style: .plain, target: self, action: #selector(showSettings))
        navigationItem.title = "Home"
        
        var buttons: [UIButton] = []
        buttons.append(busStationsButton)
        buttons.append(timetableButton)
        buttons.append(arcardButton)
        buttons.append(arweatherButton)
        
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
        
        timetableButton.setTitle("Timetable", for: .normal)
        timetableButton.addTarget(self, action: #selector(showTimetable), for: .touchUpInside)
        
        arcardButton.setTitle("AR Card", for: .normal)
        arcardButton.addTarget(self, action: #selector(showARCard), for: .touchUpInside)
        
        arweatherButton.setTitle("AR Weather", for: .normal)
        arweatherButton.addTarget(self, action: #selector(showARWeather), for: .touchUpInside)
        
        backgroundPic.image = Images.busIcon
        backgroundPic.translatesAutoresizingMaskIntoConstraints = false
        backgroundPic.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundPic)
        view.addSubview(busStationsButton)
        view.addSubview(timetableButton)
        view.addSubview(arcardButton)
        view.addSubview(arweatherButton)
    }
    
    
    private func setupConstraints() {
        backgroundPic.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        busStationsButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(self.view.snp.centerX).offset(-5)
            make.height.equalTo(150)
        }
        
        timetableButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(busStationsButton.snp.bottom)
            make.left.equalTo(self.view.snp.centerX).offset(5)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(busStationsButton.snp.height)
        }
        
        arcardButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(busStationsButton.snp.top).offset(-10)
            make.left.equalTo(busStationsButton.snp.left)
            make.right.equalTo(busStationsButton.snp.right)
            make.height.equalTo(busStationsButton.snp.height)
        }
        
        arweatherButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(timetableButton.snp.top).offset(-10)
            make.left.equalTo(timetableButton.snp.left)
            make.right.equalTo(timetableButton.snp.right)
            make.height.equalTo(timetableButton.snp.height)
        }
    }
        
    private func getUserLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
   private func checkIfUserIsLoggedIn() {
        if !userManager.isUserLoggedIn() { showLoginScreen() }
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
        self.navigationController?.pushViewController(StationsViewController(), animated: true)
    }
    
    @objc func showTimetable() {
        let storyboard = UIStoryboard(name: "TimetableCamera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "timetableARKitController")
        present(vc, animated: true, completion: nil)
    }
    
    @objc func showSettings() {
        let settingsController = SettingsViewController()
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    @objc func showARCard() {
        let storyboard = UIStoryboard(name: "ARCardCamera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "arCardViewController")
        present(vc, animated: true, completion: nil)
    }
    
    @objc func showARWeather() {
        let storyboard = UIStoryboard(name: "ARWeatherCamera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "arWeatherViewController")
        present(vc, animated: true, completion: nil)
    }
}
