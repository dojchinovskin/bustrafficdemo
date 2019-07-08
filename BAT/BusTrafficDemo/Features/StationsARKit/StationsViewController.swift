//
//  ARKITViewController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/26/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import MapKit
import ARCL
import CoreLocation
import ARKit
import SVProgressHUD

class StationsViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    let sceneLocationView = SceneLocationView()
    var twoStationsInfo: TwoStationsInfo!
    let findButton = UIButton(type: .custom)
    let closeButton = UIButton(type: .custom)

    var userLocation: UserLocation!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
        fetchNearestBusStations()
        setupViews()
        setupConstraints()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        sceneLocationView.pause()
    }
    
    private func setupViews() {
        sceneLocationView.locationViewDelegate = self
        
        findButton.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        findButton.setTitle("Find nearest stations", for: .normal)
        findButton.setTitleColor(.white, for: .normal)
        findButton.layer.cornerRadius = 5
        findButton.layer.masksToBounds = true
        findButton.addTarget(self, action: #selector(findButtonPressed), for: .touchUpInside)
        
        closeButton.setImage(Images.xButton, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
        view.addSubview(sceneLocationView)
        view.addSubview(findButton)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        sceneLocationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        findButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(closeButton.snp.top).offset(-20)
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalToSuperview().offset(-30)
            make.height.width.equalTo(50)
        }
    }
    
    private func getUserLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
        if let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude {
            userLocation = UserLocation(latitude: latitude,
                                        longitude: longitude)
        } else {
            print("Error getting user location")
        }
    }
    
    private func fetchNearestBusStations() {
        let userLocationTxt = userLocation.getLocationAsString()
        Provider.getStations(latitude: userLocationTxt.latitudeStr,
                             longitude: userLocationTxt.longitudeStr,
                             success: {
                                twoStationsInfo in
                                self.twoStationsInfo = twoStationsInfo
        }) { (error) in
            print(error)
        }
    }
    
    private func drawRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionsRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                     print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            let route = response.routes[0]
            self.sceneLocationView.addRoutes(routes: [route])
        }
    }
    
    @objc private func findButtonPressed() {
        buildDemoData().forEach {
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0)
        }
        
        if let userLocation = userLocation, let stations = twoStationsInfo {
            let location = CLLocationCoordinate2DMake(userLocation.latitude,
                                                      userLocation.longitude)
            let destinationA = CLLocationCoordinate2DMake(stations.latitude1,
                                                          stations.longitude1)
            let destinationB = CLLocationCoordinate2DMake(stations.latitude2,
                                                          stations.longitude2)
            
            drawRoute(source: location, destination: destinationA)
            drawRoute(source: location, destination: destinationB)
        } else  {
            print("Location or destination error")
        }
    }
    
    @objc private func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

private extension StationsViewController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        let firstStation = buildNode(latitude: twoStationsInfo.latitude1,
                                     longitude: twoStationsInfo.longitude1,
                                     altitude: 250,
                                     imageName: "pin")
        firstStation.scaleRelativeToDistance = true
        
        let secondStation = buildNode(latitude: twoStationsInfo.latitude2,
                                      longitude: twoStationsInfo.longitude2,
                                      altitude: 250,
                                      imageName: "pin")
        secondStation.scaleRelativeToDistance = true
        
        nodes.append(firstStation)
        nodes.append(secondStation)
        return nodes
    }
    
    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = Images.pin
        return LocationAnnotationNode(location: location, image: image)
    }
}
