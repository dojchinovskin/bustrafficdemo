//
//  ARWeather.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 95//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class ARWeather: SCNNode {
    //var cloud: SCNNode!
    var location: SCNNode!
    var currTemp: SCNNode!
    var currTempIcon: SCNNode!
    var tomorrow: SCNNode!
    var tomorrowIcon: SCNNode!
    var tomorrowMinTemp: SCNNode!
    var tomorrowMaxTemp: SCNNode!
    var afterTomorrow: SCNNode!
    var afterTomorrowIcon: SCNNode!
    var afterTomorrowMinTemp: SCNNode!
    var afterTomorrowMinTempText: SCNNode!
    var afterTomorrowMaxTemp: SCNNode!
    var afterAfterTomorrow: SCNNode!
    var afterAfterTomorrowIcon: SCNNode!
    var afterAfterTomorrowMinTemp: SCNNode!
    var afterAfterTomorrowMaxTemp: SCNNode!

    override init() {
        super.init()
        
        guard let template = SCNScene(named: "ARWeatherScene.scn"),
            let cloud = template.rootNode.childNode(withName: "Cloud", recursively: false),
            let location = cloud.childNode(withName: "Location", recursively: false),
            let currTemp = cloud.childNode(withName: "CurrTemp", recursively: false),
            let currTempIcon = cloud.childNode(withName: "CurrTempIcon", recursively: false),
            let tomorrow = cloud.childNode(withName: "Tomorrow", recursively: false),
            let tomorrowIcon = cloud.childNode(withName: "TomorrowIcon", recursively: false),
            let tomorrowMinTemp = cloud.childNode(withName: "TomorrowMinTemp", recursively: false),
            let tomorrowMaxTemp = cloud.childNode(withName: "TomorrowMaxTemp", recursively: false),
            let afterTomorrow = cloud.childNode(withName: "AfterTomorrow", recursively: false),
            let afterTomorrowIcon = cloud.childNode(withName: "AfterTomorrowIcon", recursively: false),
            let afterTomorrowMinTemp = cloud.childNode(withName: "AfterTomorrowMinTemp", recursively: false),
            let afterTomorrowMaxTemp = cloud.childNode(withName: "AfterTomorrowMaxTemp", recursively: false),
            let afterAfterTomorrow = cloud.childNode(withName: "AfterAfterTomorrow", recursively: false),
            let afterAfterTomorrowIcon = cloud.childNode(withName: "AfterAfterTomorrowIcon", recursively: false),
            let afterAfterTomorrowMinTemp = cloud.childNode(withName: "AfterAfterTomorrowMinTemp", recursively: false),
            let afterAfterTomorrowMaxTemp = cloud.childNode(withName: "AfterAfterTomorrowMaxTemp", recursively: false)
        else {
            fatalError("Error getting ARWeather nodes")
        }
        
        //self.cloud = cloud
        self.location = location
        self.currTemp = currTemp
        self.currTempIcon = currTempIcon
        self.tomorrow = tomorrow
        self.tomorrowIcon = tomorrowIcon
        self.tomorrowMinTemp = tomorrowMinTemp
        self.tomorrowMaxTemp = tomorrowMaxTemp
        self.afterTomorrow = afterTomorrow
        self.afterTomorrowIcon = afterTomorrowIcon
        self.afterTomorrowMinTemp = afterTomorrowMinTemp
        self.afterTomorrowMaxTemp = afterTomorrowMaxTemp
        self.afterAfterTomorrow = afterAfterTomorrow
        self.afterAfterTomorrowIcon = afterAfterTomorrowIcon
        self.afterAfterTomorrowMinTemp = afterAfterTomorrowMinTemp
        self.afterAfterTomorrowMaxTemp = afterAfterTomorrowMaxTemp
        
        self.addChildNode(cloud)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateNodes(_ weatherInfo: WeatherInfo) {
        if let currTempText = currTemp.geometry as? SCNText {
            currTempText.string = "\(weatherInfo.today.1) °C"
        }
        
        if let tomorrowMinTempText = tomorrowMinTemp.geometry as? SCNText,
            let tomorrowMaxTempText = tomorrowMaxTemp.geometry as? SCNText {
            tomorrowMinTempText.string = "\(weatherInfo.tomorrow.1) °C"
            tomorrowMaxTempText.string = "\(weatherInfo.tomorrow.2) °C"
        }
        
        if let afterTomorrowMinTempText = afterTomorrowMinTemp.geometry as? SCNText,
            let afterTomorrowMaxTempText = afterTomorrowMaxTemp.geometry as? SCNText {
            afterTomorrowMinTempText.string = "\(weatherInfo.afterTomorrow.1) °C"
            afterTomorrowMaxTempText.string = "\(weatherInfo.afterTomorrow.2) °C"
        }
        
        if let afterAfterTomorrowMinTempText = afterAfterTomorrowMinTemp.geometry as? SCNText,
            let afterAfterTomorrowMaxTempText = afterAfterTomorrowMaxTemp.geometry as? SCNText {
                afterAfterTomorrowMinTempText.string = "\(weatherInfo.afterAfterTomorrow.1) °C"
                afterAfterTomorrowMaxTempText.string = "\(weatherInfo.afterAfterTomorrow.2) °C"
        }
    }
    
}
