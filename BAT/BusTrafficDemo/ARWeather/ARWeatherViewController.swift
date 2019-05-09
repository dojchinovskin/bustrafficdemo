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

class ARWeatherViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let arWeather = ARWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTemperatures()
    }
    
    private func fetchTemperatures() {
        APIProvider.getWeather(latitude: "42", longitude: "21.43", success: { [weak self] weatherInfo in
            print(weatherInfo)
            self?.arWeather.updateNodes(weatherInfo)
        }, failure: { error in
            print(error)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAR()
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
        sceneView.scene.rootNode.addChildNode(arWeather)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
