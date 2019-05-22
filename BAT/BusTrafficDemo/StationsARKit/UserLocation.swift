//
//  UserLocation.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 225//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import MapKit

struct UserLocation {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    func getLocationAsString() -> (latitudeStr: String, longitudeStr: String) {
        let latitudeString = String(latitude)
        let longitudeString = String(longitude)
        return (latitudeString, longitudeString)
    }
}
