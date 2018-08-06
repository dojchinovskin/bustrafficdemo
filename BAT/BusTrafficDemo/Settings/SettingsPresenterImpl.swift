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
    
    //MARK: DEACTIVATE
    
    func deactivateAccount(email: String, password: String) {
            let emailCheck = EmailAuthProvider.credential(withEmail: email, password: password )
            self.view?.showProgressHud()
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
                self.view?.hideProgressHud()
                if let error = error {
                    self.view?.showAccountDeactivationFailure(error: error)
                } else {
                    Auth.auth().currentUser?.delete(completion: { (error) in
                        if let error = error {
                           self.view?.showAccountDeactivationFailure(error: error)
                        }
                    })
                    guard let uid = Auth.auth().currentUser?.uid else {
                        return
                    }
                    let ref = Database.database().reference(fromURL: "https://busartrafficdemo.firebaseio.com/")
                    let userReference = ref.child("users").child(uid)
                    userReference.removeValue()
                    self.view?.showAccountDeactivationSuccess()
                }
            })
    }
    
    //MARK: LOGOUT
    
    func logOut() {
        self.showLoginScreen()
        self.userManager.logOut()
    }
    
    private func showLoginScreen() {
        navigator.setLoginScreenAsRootController()
    }
    
}
