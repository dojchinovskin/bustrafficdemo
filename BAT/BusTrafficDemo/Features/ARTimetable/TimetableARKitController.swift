//
//  CameraViewController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/12/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import ARKit
import Firebase


class TimetableARKitController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var lines: [Line]!

    private var place = "Simpo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchLinesFor(place)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupViews() {
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControl), for: .valueChanged)
    }
    
    private func setupAR() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func fetchLinesFor(_ place: String) {
        lines = []
        let databaseRef = Constants.Firebase.databaseRef
        databaseRef.child("Lines").child(place).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let values = snapshot.value as? Dictionary<String, String> else { return }
            for value in values {
                let line = Line(bus: value.key, time: value.value)
                self?.lines.append(line)
            }            
        }
    }
    
    @objc private func handleSegmentedControl() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: fetchLinesFor(segmentedControl.titleForSegment(at: 0) ?? "Simpo")
        case 1: fetchLinesFor(segmentedControl.titleForSegment(at: 1) ?? "Rekord")
        default: return
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TimetableARKitController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            if let referencedImage = imageAnchor.referenceImage.name, referencedImage == "busSign" {
                let trackingNode = TrackingNode(imageAnchor.referenceImage)
                node.addChildNode(trackingNode)
                
                let action = SCNAction.sequence([.fadeOpacity(by: 0.8, duration: 0.3),
                                                 .wait(duration: 0.5),
                                                 .fadeOut(duration: 0.3)])
                trackingNode.runAction(action, completionHandler: {
                    let timetable = TimetableViewController()
                    timetable.lines = self.lines
                    DispatchQueue.main.async {
                        self.present(timetable, animated: true, completion: nil)
                    }
                })
            }
        }
    }
}


