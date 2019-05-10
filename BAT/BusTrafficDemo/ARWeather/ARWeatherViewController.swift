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
import AVFoundation

class ARWeatherViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    private let arWeather = ARWeather()
    private var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTemperatures()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
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
    
    private func fetchTemperatures() {
        APIProvider.getWeather(latitude: "42", longitude: "21.43", success: { [weak self] weatherInfo in
            self?.arWeather.updateNodes(weatherInfo)
            self?.setTextFor(weatherInfo.today.0)
            }, failure: { error in
                print(error)
        })
    }
    
    private func speakOut(text: String){
        let speech = AVSpeechUtterance(string: text)
        speech.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(speech)
    }
    
    private func setTextFor(_ weather: String) {
        if weather.lowercased().contains("rain") {
            text = "You should consider taking a bus."
        } else {
            text = "The weather is nice today."
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        if !hitResults.isEmpty {
            if let text = text {
                speakOut(text: text)
            }
        }
    }
}
