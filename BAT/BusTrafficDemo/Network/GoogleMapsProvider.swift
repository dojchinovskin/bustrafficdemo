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

typealias SuccessBlock = (TwoStationsInfo) -> Void
typealias ErrorBlock = (Error) -> Void

struct GoogleMapsProvider {
    static func getStations(latitude: String, longitude: String, success: @escaping SuccessBlock, failure: @escaping ErrorBlock) {
        Alamofire.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1000&type=bus_station&key=AIzaSyBhhGnyRKf735lvZ6eq-UtJwkHmlTeVSUQ").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let lat1 = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let long1 = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                let lat2 = json["results"][1]["geometry"]["location"]["lat"].doubleValue
                let long2 = json["results"][1]["geometry"]["location"]["lng"].doubleValue
                success(TwoStationsInfo(latitude1: lat1, longitude1: long1, latitude2: lat2, longitude2: long2))
                
            case .failure(let error):
                failure(error)
                print(error)
            }
        }
}
}
