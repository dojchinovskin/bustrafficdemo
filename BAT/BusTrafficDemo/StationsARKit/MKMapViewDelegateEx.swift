//
//  MKMapViewDelegateEx.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/30/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import MapKit

extension StationsARKitController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.displayPriority = .required
        marker.markerTintColor = UIColor(hue: 358, saturation: 0.67, brightness: 0.77, alpha: 1.0)
        marker.canShowCallout = true
        
        let openButton = UIButton(type: .custom) as UIButton
        openButton.frame.size.width = 80
        openButton.frame.size.height = 44
        openButton.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        openButton.setTitle("Maps", for: .normal)
        
        marker.rightCalloutAccessoryView = openButton
    
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let url = "https://www.google.com/maps/@\(twoStationsInfo?.latitude1 ?? 0),\(twoStationsInfo?.longitude1 ?? 0),17z"
        UIApplication.shared.open(URL(string : url)!, options:[:], completionHandler: nil)

    }
}
