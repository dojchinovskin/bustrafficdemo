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
    
    //MARK: LOGIN

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
    
    //MARK: FORGET PASSWORD
    
    func forgetPassword(email: String) {
        self.view?.showProgressHud()
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            self.view?.hideProgressHud()
            DispatchQueue.main.async {
                if let error = error {
                    self.view?.showResetPasswordFailure(error: error)
                } else {
                    self.view?.showResetPasswordSuccess()
                }
            }
        })
    }
    
}
