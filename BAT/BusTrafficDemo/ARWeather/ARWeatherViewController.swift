//
//  ARWeatherViewController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 35//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class ARWeatherViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupAR()
        setupARCloud()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    
    private func setupAR() {
        sceneView.delegate = self
        sceneView.session.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [])
    }
    
    private func setupARCloud() {
        let plane = SCNPlane(width: 0.3, height: 0.3)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "cloud")
        let planeNode = SCNNode(geometry: plane)
        planeNode.opacity = 0.3
        planeNode.position = SCNVector3(0,0,-0.5)
        sceneView.scene.rootNode.addChildNode(planeNode)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ARWeatherViewController: ARSCNViewDelegate {
    
}

extension ARWeatherViewController: ARSessionDelegate {
    
}
