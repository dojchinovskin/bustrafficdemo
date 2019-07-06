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
    private var targetAnchor: ARAnchor!
    private let arCard = ARCard()
    private var isCardPlaced = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
        sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ARCardViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            let referenceImage = imageAnchor.referenceImage
            
            if let matchedCardName = referenceImage.name, matchedCardName == "transportCard" && !self.isCardPlaced {
                self.isCardPlaced = true
                node.addChildNode(self.arCard)
                self.arCard.animateButtons()
                self.targetAnchor = imageAnchor
            }
        }
    }
}

extension ARCardViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor, imageAnchor == targetAnchor {
                if !imageAnchor.isTracked {
                    isCardPlaced = false
                    self.arCard.setBaseConfig()
                } else {
                    if !isCardPlaced {
                        self.arCard.animateButtons()
                        isCardPlaced = true
                    }
                }
            }
        }
    }
}
