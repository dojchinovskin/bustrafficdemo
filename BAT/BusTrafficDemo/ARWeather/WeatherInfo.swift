//
//  WeatherInfo.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 105//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation

struct WeatherInfo {
    var location: String
    var today: (String, String)
    var tomorrow: (String, String, String)
    var afterTomorrow: (String, String, String)
    var afterAfterTomorrow: (String, String, String)
}
