//
//  ArCardInteraction.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 244//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import SafariServices

extension ARCardViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentTouchLocation = touches.first?.location(in: self.sceneView),
        let hitResult = self.sceneView.hitTest(currentTouchLocation, options: nil).first?.node.name else { return }
        
        switch hitResult {
        case "Website": displayWebsite(urlString: "https://www.google.com")
        case "Maps": print("Maps")
        case "Phone": callNumber(number: "070000000") // jsp/skopska number
        case "Sms": sendSmsTo(number: "070000000")
        case "Email": print("Email")
        case "Info": getInfo()
        default: return
        }
    }
    
    private func getInfo() {
        let alert = UIAlertController(title: "Bus Traffic Card Info", message: "You have 250 den left.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    private func callNumber(number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Error Trying To Connect To Mobile Provider")
        }
    }
    
    private func sendSmsTo(number: String) {
        if MFMessageComposeViewController.canSendText() {
            let smsController = MFMessageComposeViewController()
            smsController.recipients = [number]
            smsController.messageComposeDelegate = self
            present(smsController, animated: true, completion: nil)
        } else {
            print("Error Loading SMS Composer")
        }
    }
    
    private func sendEmailTo(recepient: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.setToRecipients([recepient])
            mailController.mailComposeDelegate = self
            present(mailController, animated: true, completion: nil)
        } else {
            print("Error loading Mail Composer")
        }
    }
    
    private func displayWebsite(urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else {
            print("Error displaying Safari controller")
        }
    }
}

extension ARCardViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}

extension ARCardViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

