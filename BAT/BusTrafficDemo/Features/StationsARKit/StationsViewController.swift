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
    let mapView = MKMapView()
    let findButton = UIButton(type: .custom)

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
        sceneLocationView.locationDelegate = self
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.alpha = 0.8
        
        let delta: CLLocationDegrees = 0.005
        let span = MKCoordinateSpanMake(delta, delta)
        let location = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude) ?? 42, (locationManager.location?.coordinate.longitude) ?? 21)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: false)
        
        findButton.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        findButton.setTitle("Find nearest station", for: .normal)
        findButton.setTitleColor(.white, for: .normal)
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.layer.cornerRadius = 5
        findButton.layer.masksToBounds = true
        findButton.addTarget(self, action: #selector(findButtonPressed), for: .touchUpInside)
        
        view.addSubview(sceneLocationView)
        view.addSubview(mapView)
        view.addSubview(findButton)
    }
    
    private func setupConstraints() {
        sceneLocationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        mapView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(self.view.frame.height / 2)
        }
        
        findButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(50)
        }
    }
    
    private func calculateUserDistance(from point: MKPointAnnotation) -> Double {
        guard let userLocation = mapView.userLocation.location else { return 0 }
        let pointLocation = CLLocation(
            latitude:  point.coordinate.latitude,
            longitude: point.coordinate.longitude
        )
        return userLocation.distance(from: pointLocation)
    }
    
    private func getUserLocation() {
        SVProgressHUD.show(withStatus: "Please wait")
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
    
    private func setAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.coordinate = coordinate
        let distance = calculateUserDistance(from: annotation)
        let distanceTxt = String(Int(distance))
        annotation.title = "Bus station: \n" + "~" + distanceTxt + "m"
        mapView.addAnnotation(annotation)
        return annotation
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
            self.mapView.add(route.polyline, level: .aboveRoads)
        }
    }
    
    @objc private func findButtonPressed() {
        buildDemoData().forEach {
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0)
        }
        
        let firstAnnotation = setAnnotation(latitude: twoStationsInfo.latitude1,
                                            longitude: twoStationsInfo.longitude1)
        let secondAnnotation = setAnnotation(latitude: twoStationsInfo.latitude2,
                                             longitude: twoStationsInfo.longitude2)
        
        guard let userLocation = mapView.userLocation.location?.coordinate else { return }
        drawRoute(source: userLocation, destination: firstAnnotation.coordinate)
        drawRoute(source: userLocation, destination: secondAnnotation.coordinate)
    }
    
    func fetchNearestBusStations() {
        let userLocationTxt = userLocation.getLocationAsString()
        Provider.getStations(latitude: userLocationTxt.latitudeStr,
                                longitude: userLocationTxt.longitudeStr,
                                success: {
                                    twoStationsInfo in
                                    self.twoStationsInfo = twoStationsInfo
                                    SVProgressHUD.dismiss()
                                }) { (error) in
                                    print(error)
        }
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
