//
//  ARCardViewController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 224//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import ARKit
import SnapKit

class ARCardViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupAR()
    }
    
    private func setupAR() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension ARCardViewController: ARSCNViewDelegate, ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            let referenceImage = imageAnchor.referenceImage
            
            if let matchedBusinessCardName = referenceImage.name, matchedBusinessCardName == "businessCard" {
                let arCard = ARCard()
                node.addChildNode(arCard)
                arCard.animateButtons()
                
                
                
            }
            
            
        }
    }
}
