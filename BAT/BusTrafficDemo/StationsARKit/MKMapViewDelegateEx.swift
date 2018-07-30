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
        
        return marker
    }
}
