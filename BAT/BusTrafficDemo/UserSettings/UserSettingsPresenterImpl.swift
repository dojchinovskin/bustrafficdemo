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
    
    func resetPassword() {
        let changePasswordAlert = UIAlertController(title: "Edit your password", message: "Enter your email and password", preferredStyle: .alert)
        changePasswordAlert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Enter your email"
        }
        changePasswordAlert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Enter your password"
            passwordTextField.isSecureTextEntry = true
        }
        changePasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changePasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let email = changePasswordAlert.textFields?[0].text
            let password = changePasswordAlert.textFields?[1].text
            let emailCheck = EmailAuthProvider.credential(withEmail: email!, password: password! )
            self.view?.showProgressHud()
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
                self.view?.hideProgressHud()
                if let error = error {
                    let FailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
                    FailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.view?.presentAlert(viewController: FailedAlert)
                    return
                }
                let newPasswordAlert = UIAlertController(title: "New Password", message: "Enter your new password", preferredStyle: .alert)
                newPasswordAlert.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "Enter your new password"
                        textField.isSecureTextEntry = true
                    })
                    newPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    newPasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let email = newPasswordAlert.textFields?.first?.text
                        self.view?.showProgressHud()
                        Auth.auth().currentUser?.updatePassword(to: email!, completion: { (error) in
                            self.view?.hideProgressHud()
                                if let error = error {
                                    let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
                                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.view?.presentAlert(viewController: resetFailedAlert)
                                    return
                                }
                                let resetPasswordSentAlert = UIAlertController(title: "Changed password successfully", message: "Your new password has been set.", preferredStyle: .alert)
                                resetPasswordSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.view?.presentAlert(viewController: resetPasswordSentAlert)
                            
                        })
                    }))
                    self.view?.presentAlert(viewController: newPasswordAlert)
                })
            }))
        self.view?.presentAlert(viewController: changePasswordAlert)
    }
    
    func resetEmail() {
        let changeEmailAlert = UIAlertController(title: "Edit your email", message: "Enter your old email and password", preferredStyle: .alert)
            changeEmailAlert.addTextField { (emailTextField) in
                emailTextField.placeholder = "Enter your old email"
            }
            changeEmailAlert.addTextField { (passwordTextField) in
                passwordTextField.placeholder = "Enter your password"
                passwordTextField.isSecureTextEntry = true
            }
            changeEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            changeEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let email = changeEmailAlert.textFields?[0].text
                let password = changeEmailAlert.textFields?[1].text
                let emailCheck = EmailAuthProvider.credential(withEmail: email!, password: password! )
                self.view?.showProgressHud()
                Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
                    self.view?.hideProgressHud()
                    if let error = error {
                        let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.view?.presentAlert(viewController: resetFailedAlert)
                        return
                    }
                    let newEmailAlert = UIAlertController(title: "New Email", message: "Enter your new email", preferredStyle: .alert)
                    newEmailAlert.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "Enter your new email"
                    })
                    newEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    newEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        let newEmail = newEmailAlert.textFields?.first?.text
                        self.view?.showProgressHud()
                        Auth.auth().currentUser?.updateEmail(to: newEmail!, completion: { (error) in
                            self.view?.hideProgressHud()
                                if let error = error {
                                    let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
                                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.view?.presentAlert(viewController: resetFailedAlert)
                                    return
                                }
                                let resetEmailSentAlert = UIAlertController(title: "Changed email successfully", message: "Your new email has been set.", preferredStyle: .alert)
                                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                                guard let uid = Auth.auth().currentUser?.uid else {
                                    return
                                }

                                let ref = Database.database().reference(fromURL: "https://busartrafficdemo.firebaseio.com/")
                                let userReference = ref.child("users").child(uid)
                                let values = ["email": newEmail]
                                userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                                    if err != nil {
                                        print(err!)
                                        return
                                    }
                                })
                                self.view?.presentAlert(viewController: resetEmailSentAlert)
                            
                        })
                    }))
                    self.view?.presentAlert(viewController: newEmailAlert)
                })
        }))
        self.view?.presentAlert(viewController: changeEmailAlert)
    }
    
    func resetName() {
        let changeNameAlert = UIAlertController(title: "Edit your name", message: "Enter your email and password", preferredStyle: .alert)
        changeNameAlert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Enter your email"
        }
        changeNameAlert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Enter your password"
            passwordTextField.isSecureTextEntry = true
        }
        
        changeNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let email = changeNameAlert.textFields?[0].text
            let password = changeNameAlert.textFields?[1].text
            let emailCheck = EmailAuthProvider.credential(withEmail: email!, password: password! )
            self.view?.showProgressHud()
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: emailCheck, completion: { (result, error) in
                self.view?.hideProgressHud()
                if let error = error {
                    let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.view?.presentAlert(viewController: resetFailedAlert)
                    return
                }
                let newNameAlert = UIAlertController(title: "New Name", message: "Enter your new name", preferredStyle: .alert)
                newNameAlert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Enter your new name"
                })
                newNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                newNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    guard let newName = newNameAlert.textFields?.first?.text else { return }
                    if newName.isEmpty {
                        let resetFailedAlert2 = UIAlertController(title: "Editing Failed", message: "You didn't submit anything.", preferredStyle: .alert)
                        resetFailedAlert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.view?.presentAlert(viewController: resetFailedAlert2)
                        return
                    }
                    guard let uid = Auth.auth().currentUser?.uid else {
                        return
                    }
                    
                    let ref = Database.database().reference(fromURL: "https://busartrafficdemo.firebaseio.com/")
                    let userReference = ref.child("users").child(uid)
                    let values = ["name": newName]
                    userReference.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err!)
                            return
                        }
                    })
                    let newNameSetAlert = UIAlertController(title: "Changed name successfully", message: "Your new name has been set.", preferredStyle: .alert)
                    newNameSetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.view?.presentAlert(viewController: newNameSetAlert)
                }))
                self.view?.presentAlert(viewController: newNameAlert)
            })
        }))
        self.view?.presentAlert(viewController: changeNameAlert)
    }
}
