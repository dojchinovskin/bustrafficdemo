//
//  ARKITViewController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/26/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import ARCL
import SnapKit
import Alamofire
import SwiftyJSON
import CoreLocation

class StationsARKitController: UIViewController, CLLocationManagerDelegate {
    let sceneLocationView = SceneLocationView()
    
    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var stationLatitude: CLLocationDegrees?
    var stationLongitude: CLLocationDegrees?
    var stationLatitude2: CLLocationDegrees?
    var stationLongitude2: CLLocationDegrees?
    
    let locationManager = CLLocationManager()
    
    lazy var nearestStationButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.setTitle("Find nearest station", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(nearestStation), for: .touchUpInside)
        
        return button
    }()
    
    @objc func nearestStation() {
        buildDemoData().forEach {
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0)
        }
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: self.stationLatitude!, longitude: self.stationLongitude!)
        annotation.coordinate = centerCoordinate
        let distance = userDistance(from: annotation)
        let dis = String(format:"%d", Int(distance!))
        annotation.title = "Bus station: \n" + "~" + dis + "m"
        mapView.addAnnotation(annotation)
        
        let annotation2 = MKPointAnnotation()
        let centerCoordinate2 = CLLocationCoordinate2D(latitude: self.stationLatitude2!, longitude: self.stationLongitude2!)
        annotation2.coordinate = centerCoordinate2
        let distance2 = userDistance(from: annotation2)
        let dis2 = String(format:"%d", Int(distance2!))
        annotation2.title = "Bus station: \n" + "~" + dis2 + "m"
        mapView.addAnnotation(annotation2)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocation()
        apiCall()
        
//        navigationController?.navigationBar.isHidden = true
//        UIApplication.shared.isStatusBarHidden = true
        
        sceneLocationView.locationDelegate = self
        view.addSubview(sceneLocationView)
        
        mapSetup()
    }
    
    func userDistance(from point: MKPointAnnotation) -> Double? {
        guard let userLocation = mapView.userLocation.location else {
            return nil // User location unknown!
        }
        let pointLocation = CLLocation(
            latitude:  point.coordinate.latitude,
            longitude: point.coordinate.longitude
        )
        return userLocation.distance(from: pointLocation)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("run")
        sceneLocationView.run()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("pause")
        // Pause the view's session
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
        mapView.frame = CGRect(
            x: 0,
            y: self.view.frame.size.height / 2,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height / 2)
        
        nearestStationButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
    func userLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func apiCall() {
        
        let lat = String(format:"%f", locationManager.location?.coordinate.latitude ?? 0)
        let lon = String(format:"%f", locationManager.location?.coordinate.longitude ?? 0)
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=1000&type=bus_station&key=AIzaSyBhhGnyRKf735lvZ6eq-UtJwkHmlTeVSUQ"
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let latitude = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let longitude = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                let latitude2 = json["results"][1]["geometry"]["location"]["lat"].doubleValue
                let longitude2 = json["results"][1]["geometry"]["location"]["lng"].doubleValue
                self.stationLatitude = latitude
                self.stationLongitude = longitude
                self.stationLatitude2 = latitude2
                self.stationLongitude2 = longitude2
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func mapSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.alpha = 0.8
        
        let latDelta:CLLocationDegrees = 0.005
        let lonDelta:CLLocationDegrees = 0.005
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
        
        
        view.addSubview(mapView)
        view.addSubview(nearestStationButton)
    }
    
    @objc func updateUserLocation() {
        guard let currentLocation = sceneLocationView.currentLocation() else {
            return
        }
        
        DispatchQueue.main.async {
            if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                let position = self.sceneLocationView.currentScenePosition() {
                print("")
                print("Fetch current location")
                print("best location estimate, position: \(bestEstimate.position), location: \(bestEstimate.location.coordinate), accuracy: \(bestEstimate.location.horizontalAccuracy), date: \(bestEstimate.location.timestamp)")
                print("current position: \(position)")
                
                let translation = bestEstimate.translatedLocation(to: position)
                
                print("translation: \(translation)")
                print("translated location: \(currentLocation)")
                print("")
            }
            
            if self.userAnnotation == nil {
                self.userAnnotation = MKPointAnnotation()
                self.mapView.addAnnotation(self.userAnnotation!)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.userAnnotation?.coordinate = currentLocation.coordinate
            }, completion: nil)
        }
    }
}

private extension StationsARKitController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        let station = buildNode(latitude: stationLatitude!, longitude: stationLongitude!, altitude: 250, imageName: "pin")
        station.scaleRelativeToDistance = true
        nodes.append(station)
        
        let station2 = buildNode(latitude: stationLatitude2!, longitude: stationLongitude2!, altitude: 250, imageName: "pin")
        station2.scaleRelativeToDistance = true
        nodes.append(station2)
        
        return nodes
    }
    
    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = UIImage(named: "pin")!
        return LocationAnnotationNode(location: location, image: image)
    }
}


