//
//  LoginPresenter.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/21/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Firebase

class LoginPresenterImpl: LoginPresenter {
    
    var view: LoginView?
    let errorEmailString = "There is no user record corresponding to this identifier. The user may have been deleted."
    let errorPasswordString = "The password is invalid or the user does not have a password."

    func attach(view: LoginView) {
        self.view = view
    }

    func dettach(view: LoginView) {
        if let myView = self.view {
            if myView === view {
                self.view = nil
            }
        }
    }

    func login(email: String, password: String) {
        view?.showProgressHud()

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            self?.view?.hideProgressHud()

            if error != nil {
                print("\(error!)")
                if error?.localizedDescription == self?.errorEmailString {
                    self?.view?.showWrongEmail()
                }
                
                if error?.localizedDescription == self?.errorPasswordString {
                    self?.view?.showWrongPassword()
                }
                return
            }
            self?.view?.loginSuccess()
        }
    }
    
    func forgetPassword() {
        let forgotPasswordAlert = UIAlertController(title: "Are you sure you want to reset your password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter your email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            self.view?.showProgressHud()
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                self.view?.hideProgressHud()
                DispatchQueue.main.async {
                    if let error = error {
                        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.view?.showResetPasswordFailure(viewController: resetFailedAlert)
                    } else {
                        let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.view?.showResetPasswordSuccess(viewController: resetEmailSentAlert)
                    }
                }
            })
        }))
        self.view?.showConfirmationPassword(viewController: forgotPasswordAlert)
    }
}
