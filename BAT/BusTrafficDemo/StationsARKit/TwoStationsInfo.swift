//
//  TwoStationsInfo.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 8/10/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation

class TwoStationsInfo {
    var latitude1: Double
    var longitude1: Double
    var latitude2: Double
    var longitude2: Double
    
    init(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) {
        self.latitude1 = latitude1
        self.longitude1 = longitude1
        self.latitude2 = latitude2
        self.longitude2 = longitude2
    }
}
