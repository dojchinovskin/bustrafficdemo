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
            if let error = error {
                self?.view?.showError(error: error.localizedDescription)
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
            let message = error?.localizedDescription ?? "Check your email."
            self.view?.showPasswordResetStatus(message: message)
        })
    }
}
