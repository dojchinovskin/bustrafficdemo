//
//  ARCard.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 234//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import ARKit

class ARCard: SCNNode {
    private var cardTarget: SCNNode!
    private var phoneButton: SCNNode!
    private var smsButton: SCNNode!
    private var websiteButton: SCNNode!
    private var mapsButton: SCNNode!
    private var emailButton: SCNNode!
    
    private var buttons: [SCNNode] = []
    
    override init() {
        super.init()
        
        guard let template = SCNScene(named: "ARCardScene.scn"),
            let rootNode = template.rootNode.childNode(withName: "RootNode", recursively: false),
            let target = rootNode.childNode(withName: "CardTarget", recursively: false),
            let phoneButton = rootNode.childNode(withName: "Phone", recursively: false),
            let smsButton = rootNode.childNode(withName: "Sms", recursively: false),
            let websiteButton = rootNode.childNode(withName: "Website", recursively: false),
            let mapsButton = rootNode.childNode(withName: "Maps", recursively: false),
            let emailButton = rootNode.childNode(withName: "Email", recursively: false)
        else {
            fatalError("Error getting ARCard nodes")
        }
        
        self.cardTarget = target
        self.phoneButton = phoneButton
        self.smsButton = smsButton
        self.websiteButton = websiteButton
        self.mapsButton = mapsButton
        self.emailButton = emailButton
        
        buttons.append(phoneButton)
        buttons.append(smsButton)
        buttons.append(websiteButton)
        buttons.append(mapsButton)
        buttons.append(emailButton)
        
        cardTarget.isHidden = true
//        phoneButton.rotation = SCNVector4Make(0, 1, 0, GLKMathDegreesToRadians(180))
//        smsButton.rotation = SCNVector4Make(0, 1, 0, GLKMathDegreesToRadians(180))
//        websiteButton.rotation = SCNVector4Make(0, 1, 0, GLKMathDegreesToRadians(180))
//        mapsButton.rotation = SCNVector4Make(0, 1, 0, GLKMathDegreesToRadians(180))
        buttons.forEach { $0.rotation = SCNVector4Make(0, 1, 0, GLKMathDegreesToRadians(180)) }
        
        self.addChildNode(rootNode)
        self.eulerAngles.x = -.pi / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateButtons() {
        let rotationAsRadian = CGFloat(GLKMathDegreesToRadians(180))
        let flipAction = SCNAction.rotate(by: rotationAsRadian, around: SCNVector3(0, 1, 0), duration: 1.5)
        
        buttons.forEach { $0.runAction(flipAction) }
    }
    

}
