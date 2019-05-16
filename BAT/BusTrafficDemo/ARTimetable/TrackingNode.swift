//
//  TrackingNode.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 145//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class TrackingNode: SCNNode {
    
    init(_ image: ARReferenceImage) {
        super.init()
        
        let plane = SCNPlane(width: image.physicalSize.width, height: image.physicalSize.height)
        self.geometry = plane
        self.eulerAngles.x = -.pi / 2
        self.opacity = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Line {
    let bus: String
    let time: String
}
