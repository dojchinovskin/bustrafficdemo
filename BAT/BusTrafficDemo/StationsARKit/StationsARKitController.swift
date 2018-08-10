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
import ARKit
import SVProgressHUD

class StationsARKitController: UIViewController, CLLocationManagerDelegate {
    let sceneLocationView = SceneLocationView()
    var twoStationsInfo: TwoStationsInfo?
    
    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var userLatitude: String?
    var userLongitude: String?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLocation()
        fetchNearestBusStations()
        setupViews()
        mapSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("run")
        self.sceneLocationView.run()
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
    
    func userLocation() {
        SVProgressHUD.show(withStatus: "Please wait")
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        userLatitude = String(format:"%f", locationManager.location?.coordinate.latitude ?? 0)
        userLongitude = String(format:"%f", locationManager.location?.coordinate.longitude ?? 0)
    }
    
    
    @objc func nearestStation() {
        buildDemoData().forEach {
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0)
        }
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: (self.twoStationsInfo?.latitude1)!, longitude: (self.twoStationsInfo?.longitude1)!)
        annotation.coordinate = centerCoordinate
        let distance = userDistance(from: annotation)
        let dis = String(format:"%d", Int(distance!))
        annotation.title = "Bus station: \n" + "~" + dis + "m"
        mapView.addAnnotation(annotation)
        
        let annotation2 = MKPointAnnotation()
        let centerCoordinate2 = CLLocationCoordinate2D(latitude: (self.twoStationsInfo?.latitude2)!, longitude: (self.twoStationsInfo?.longitude2)!)
        annotation2.coordinate = centerCoordinate2
        let distance2 = userDistance(from: annotation2)
        let dis2 = String(format:"%d", Int(distance2!))
        annotation2.title = "Bus station: \n" + "~" + dis2 + "m"
        mapView.addAnnotation(annotation2)
    }
    
    func fetchNearestBusStations() {
        GoogleMapsProvider.getStations(latitude: userLatitude!, longitude: userLongitude!, success: {
            twoStationsInfo in
            self.twoStationsInfo = twoStationsInfo
            SVProgressHUD.dismiss()
        }) { (error) in
            print(error)
        }
    }
    
    func setupViews() {
        sceneLocationView.locationDelegate = self
        view.addSubview(sceneLocationView)
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
}

private extension StationsARKitController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        let station = buildNode(latitude: (twoStationsInfo?.latitude1)!, longitude: (twoStationsInfo?.longitude1)!, altitude: 250, imageName: "pin")
        station.scaleRelativeToDistance = true
        nodes.append(station)
        
        let station2 = buildNode(latitude: (twoStationsInfo?.latitude2)!, longitude: (twoStationsInfo?.longitude2)!, altitude: 250, imageName: "pin")
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


