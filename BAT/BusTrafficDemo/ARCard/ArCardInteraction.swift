//
//  ArCardInteraction.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 244//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit

extension ARCardViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentTouchLocation = touches.first?.location(in: self.sceneView),
        let hitResult = self.sceneView.hitTest(currentTouchLocation, options: nil).first?.node.name else { return }
        
        switch hitResult {
        case "Website": print("Website")
        case "Maps": print("Maps")
        case "Phone": print("Phone")
        case "Sms": print("Sms")
        case "Email": print("Email")
        default: return
        }
    }
}
