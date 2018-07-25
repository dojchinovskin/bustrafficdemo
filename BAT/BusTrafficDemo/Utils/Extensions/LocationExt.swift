//
//  LocationExt.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/24/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import CoreLocation

extension CameraViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        locationManager.stopUpdatingLocation()
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Why I am getting this error in only in iPhone X only.
        print("error:: (error)")
    }
}
