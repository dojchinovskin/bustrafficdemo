//
//  Constants.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 255//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import Firebase

struct Constants {
    struct Firebase {
        static let databaseRef = Database.database().reference(fromURL: "https://arbustraffic.firebaseio.com/")
    }
    
    struct DarkSky {
        static let key = "808a30a6bbd354bd8ae98dc386f1c004"
        static let parameters = "minutely,hourly,alerts,flags"
        static let units = "si"
    }
    
    struct GoogleMaps {
        static let key = "AIzaSyBhhGnyRKf735lvZ6eq-UtJwkHmlTeVSUQ"
        static let radius = "1000"
        static let type = "bus_station"
    }
}
