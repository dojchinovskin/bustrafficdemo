//
//  MKMapViewDelegation.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/30/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import MapKit

extension StationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(r: 161, g: 117, b: 170)
        renderer.lineWidth = 2.5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.displayPriority = .required
        
        return marker
    }
    
}
