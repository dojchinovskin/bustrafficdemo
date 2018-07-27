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

class ARKITViewController: UIViewController, CLLocationManagerDelegate {
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
        
        buildDemoData().forEach { sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0) }
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: self.stationLatitude!, longitude: self.stationLongitude!)
        annotation.coordinate = centerCoordinate
        annotation.title = "Bus station"
        mapView.addAnnotation(annotation)
        
        let annotation2 = MKPointAnnotation()
        let centerCoordinate2 = CLLocationCoordinate2D(latitude: self.stationLatitude2!, longitude: self.stationLongitude2!)
        annotation2.coordinate = centerCoordinate2
        annotation2.title = "Bus station"
        mapView.addAnnotation(annotation2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
        
        
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = true
        
        sceneLocationView.locationDelegate = self
                
        view.addSubview(sceneLocationView)
        
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

// MARK: - MKMapViewDelegate
@available(iOS 11.0, *)
extension ARKITViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.displayPriority = .required
        
        if pointAnnotation == self.userAnnotation {
            marker.glyphImage = UIImage(named: "user")
        } else {
            marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
            marker.glyphImage = UIImage(named: "compass")
        }
        
        return marker
    }
}

// MARK: - SceneLocationViewDelegate
@available(iOS 11.0, *)
extension ARKITViewController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        //print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        //print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }

}

private extension ARKITViewController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        // TODO: add a few more demo points of interest.
        // TODO: use more varied imagery.
        
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


