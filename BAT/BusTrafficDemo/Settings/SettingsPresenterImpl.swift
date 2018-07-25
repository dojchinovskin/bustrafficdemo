//
//  SettingsPresenterImpl.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/4/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Firebase

class SettingsPresenterImpl: SettingsPresenter {
    
    private let userManager: UserManager = MainAssembly().getUserManager()
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    var view: SettingsView?
    
    func attach(view: SettingsView) {
        self.view = view
    }
    
    func dettach(view: SettingsView) {
        if let myView = self.view {
            if myView === view {
                self.view = nil
            }
        }
    }
    
    func deactivateAccount() {
        let deleteAccAlert = UIAlertController(title: "Deactivate your account", message: "Enter your email and password", preferredStyle: .alert)
        deleteAccAlert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Enter your email"
        }
        deleteAccAlert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Enter your password"
            passwordTextField.isSecureTextEntry = true
        }
        deleteAccAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteAccAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let email = deleteAccAlert.textFields?[0].text
            let password = deleteAccAlert.textFields?[1].text
            let emailCheck = EmailAuthProvider.credential(withEmail: email!, password: password! )
            self.view?.showProgressHud()
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
                self.view?.hideProgressHud()
                if let error = error {
                    let FailedAlert = UIAlertController(title: "Failed To Deactivate", message: error.localizedDescription, preferredStyle: .alert)
                    FailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.view?.presentAlert(viewController: FailedAlert)
                    
                } else {
                    let deleteSuccAlert = UIAlertController(title: "Deactivate Account", message: "Are you sure you want to deactivate your account?", preferredStyle: .alert)
                    
                    deleteSuccAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    deleteSuccAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        Auth.auth().currentUser?.delete(completion: { (error) in
                                if let error = error {
                                    let resetFailedAlert = UIAlertController(title: "Failed To Deactivate", message: error.localizedDescription, preferredStyle: .alert)
                                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.view?.presentAlert(viewController: resetFailedAlert)
                                }
                            
                        })
                        guard let uid = Auth.auth().currentUser?.uid else {
                            return
                        }
                        let ref = Database.database().reference(fromURL: "https://busartrafficdemo.firebaseio.com/")
                        let userReference = ref.child("users").child(uid)
                        userReference.removeValue()
                        let removeDatAlert = UIAlertController(title: "Deactivate Your Account", message: "Your account has been deactivated.", preferredStyle: .alert)
                        removeDatAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.logOut()
                        }))
                        self.view?.presentAlert(viewController: removeDatAlert)
                    }))
                    self.view?.presentAlert(viewController: deleteSuccAlert)
                }
            })
        }))
        self.view?.presentAlert(viewController: deleteAccAlert)
    }
    
    @objc func logOut() {
        let logOutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        logOutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.showLoginScreen()
            self.userManager.logOut()
        }))
        logOutAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.view?.presentAlert(viewController: logOutAlert)
    }
    
    private func showLoginScreen() {
        navigator.setLoginScreenAsRootController()
    }
    
}
