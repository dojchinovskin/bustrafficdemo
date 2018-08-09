//
//  GoogleMapsProvider.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 8/7/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias SuccessBlock = (Double, Double, Double, Double) -> Void
typealias ErrorBlock = (Error) -> Void

struct GoogleMapsProvider {
    
    static func getStations(latitude: String, longitude: String, success: @escaping SuccessBlock, failure: @escaping ErrorBlock) {
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1000&type=bus_station&key=AIzaSyBhhGnyRKf735lvZ6eq-UtJwkHmlTeVSUQ").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let latitude = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let longitude = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                let latitude2 = json["results"][1]["geometry"]["location"]["lat"].doubleValue
                let longitude2 = json["results"][1]["geometry"]["location"]["lng"].doubleValue
                success(latitude, longitude, latitude2, longitude2)
                //                self.stationLatitude = latitude
                //                self.stationLongitude = longitude
                //                self.stationLatitude2 = latitude2
                //                self.stationLongitude2 = longitude2
                print(latitude, longitude, latitude2, longitude2)
                
            case .failure(let error):
                failure(error)
                print(error)
            }
        }
}
}
