//
//  SceneKitExt.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/12/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import ARKit

extension CameraViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor,
                let imageName = imageAnchor.referenceImage.name else { return }
            
//            let planeNode = self.getPlaneNode(withReferenceImage: imageAnchor.referenceImage)
//            planeNode.opacity = 0.0
//            planeNode.eulerAngles.x = -.pi / 2
//            planeNode.runAction(self.fadeAction, completionHandler: {
//                self.present(TimetableController(), animated: true, completion: nil)
//            })
//            node.addChildNode(planeNode)
            
            guard let currentFrame = self.sceneView.session.currentFrame else {
                return
            }
            
            
//            guard let url = URL(string: "https://www.google.com/maps/@\(self.latitude ),\(self.longitude )") else { return }
            
//            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
//            let request = URLRequest(url: url)
            
//            webView.loadRequest(request)
            
            let tvPlane = SCNPlane(width: 1.0, height: 0.75)
//            tvPlane.firstMaterial?.diffuse.contents = webView
            tvPlane.firstMaterial?.isDoubleSided = true
            
            let tvPlaneNode = SCNNode(geometry: tvPlane)
            
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.0
            
            tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
            tvPlaneNode.eulerAngles = SCNVector3(0,0,0)
            
            self.sceneView.scene.rootNode.addChildNode(tvPlaneNode)

            
            
            self.label.text = "Image detected: \"\(imageName)\""
        }
    }
    
    func getPlaneNode(withReferenceImage image: ARReferenceImage) -> SCNNode {
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        let node = SCNNode(geometry: plane)
        return node
    }
}
