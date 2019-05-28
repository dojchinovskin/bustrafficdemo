//
//  Navigator.swift
//  BusTrafficDemo
//
//  Created by Aleksandar Jovchevski on 6/21/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

protocol Navigator {
    func setHomeScreenAsRootController()
    func setLoginScreenAsRootController()
}

class NavigatorImpl: Navigator {

    private func getMainWindow() -> UIWindow? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let mainWindow = appDelegate.window {
                return mainWindow
            }

            let window = UIWindow(frame: UIScreen.main.bounds)
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
        return nil
    }

    func setHomeScreenAsRootController() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        getMainWindow()?.setRootViewController(homeViewController, options: options)
    }

    func setLoginScreenAsRootController() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        var options = UIWindow.TransitionOptions()
        options.direction = .fade
        getMainWindow()?.setRootViewController(loginViewController, options: options)        
    }

}
