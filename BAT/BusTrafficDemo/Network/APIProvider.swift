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

typealias WeatherSuccess = (WeatherInfo) -> Void
typealias WeatherError = (Error) -> Void

struct APIProvider {
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
    
    static func getWeather(latitude: String, longitude: String, success: @escaping WeatherSuccess, failure: @escaping WeatherError) {
        let darkSkyEndpoint = "https://api.darksky.net/forecast/808a30a6bbd354bd8ae98dc386f1c004/\(latitude),\(longitude)?units=si&exclude=minutely,hourly,alerts,flags"
        
        Alamofire.request(darkSkyEndpoint).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let location = json["timezone"].stringValue
                let currTemp = json["currently"]["temperature"].intValue
                let currTempIcon = json["currently"]["icon"].stringValue
                let tomorrowMinTemp = json["daily"]["data"][0]["temperatureLow"].intValue
                let tomorrowIcon = json["daily"]["data"][0]["icon"].stringValue
                let tomorrowMaxTemp = json["daily"]["data"][0]["temperatureHigh"].intValue
                let afterTomorrowMinTemp = json["daily"]["data"][1]["temperatureLow"].intValue
                let afterTomorrowMaxTemp = json["daily"]["data"][1]["temperatureHigh"].intValue
                let afterTomorrowIcon = json["daily"]["data"][1]["icon"].stringValue
                let afterAfterTomorrowMinTemp = json["daily"]["data"][2]["temperatureLow"].intValue
                let afterAfterTomorrowMaxTemp = json["daily"]["data"][2]["temperatureHigh"].intValue
                let afterAfterTomorrowIcon = json["daily"]["data"][2]["icon"].stringValue
                
                let currTempString = String(currTemp)
                let tomorrowMinTempString = String(tomorrowMinTemp)
                let tomorrowMaxTempString = String(tomorrowMaxTemp)
                let afterTomorrowMinTempString = String(afterTomorrowMinTemp)
                let afterTomorrowMaxTempString = String(afterTomorrowMaxTemp)
                let afterAfterTomorrowMinTempString = String(afterAfterTomorrowMinTemp)
                let afterAfterTomorrowMaxTempString = String(afterAfterTomorrowMaxTemp)
                let city = String(location.split(separator: "/").last ?? "Location error")
                
                success(WeatherInfo(
                    location: city,
                    today: (currTempIcon, currTempString),
                    tomorrow: (tomorrowIcon, tomorrowMinTempString, tomorrowMaxTempString),
                    afterTomorrow: (afterTomorrowIcon, afterTomorrowMinTempString, afterTomorrowMaxTempString),
                    afterAfterTomorrow:(afterAfterTomorrowIcon, afterAfterTomorrowMinTempString, afterAfterTomorrowMaxTempString)))
                
            case .failure(let error):
                failure(error)
                print(error)
            }
        }
    }
}
