//
//  UserSettingsPresenterImpl.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/29/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class UserSettingsPresenterImpl: UserSettingsPresenter {
    
    var view: UserSettingsView?

    func attach(view: UserSettingsView) {
        self.view = view
    }
    
    func dettach(view: UserSettingsView) {
        if let myView = self.view {
            if myView === view {
                self.view = nil
            }
        }
    }
    
    //MARK: RESET NAME
    
    func reauthenticateName(email: String, password: String) {
        let emailCheck = EmailAuthProvider.credential(withEmail: email, password: password)
        self.view?.showProgressHud()
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
            self.view?.hideProgressHud()
            if let error = error {
                self.view?.showFailure(error: error.localizedDescription)
                return
            }
            self.view?.reauthenticateName()
        })
    }
    
    func updateName(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Constants.Firebase.databaseRef
        let userReference = ref.child("users").child(uid)
        let values = ["name": name]
        userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
        self.view?.showUpdate(title: "name")
    }
    
    //MARK: RESET EMAIL
    
    func reauthenticateEmail(email: String, password: String) {
        let emailCheck = EmailAuthProvider.credential(withEmail: email, password: password)
        self.view?.showProgressHud()
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
            self.view?.hideProgressHud()
            if let error = error {
                self.view?.showFailure(error: error.localizedDescription)
                return
            }
            self.view?.reauthenticateEmail()
        })
    }
    
    func updateEmail(email: String) {
        self.view?.showProgressHud()
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            self.view?.hideProgressHud()
            if let error = error {
                self.view?.showFailure(error: error.localizedDescription)
                return
            }
            self.view?.showUpdate(title: "email")
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let ref = Constants.Firebase.databaseRef
            let userReference = ref.child("users").child(uid)
            let values = ["email": email]
            userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
            })
        })
    }
    
    //MARK: RESET PASSWORD
    
    func reauthenticatePassword(email: String, password: String) {
        let emailCheck = EmailAuthProvider.credential(withEmail: email, password: password)
        self.view?.showProgressHud()
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
            self.view?.hideProgressHud()
            if let error = error {
                self.view?.showFailure(error: error.localizedDescription)
                return
            }
            self.view?.reauthenticatePassword()
        })
    }
    
    func updatePassword(email: String) {
        self.view?.showProgressHud()
        Auth.auth().currentUser?.updatePassword(to: email, completion: { (error) in
            self.view?.hideProgressHud()
            if let error = error {
                self.view?.showFailure(error: error.localizedDescription)
                return
            }
            self.view?.showUpdate(title: "password")
        })
    }
}
