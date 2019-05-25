//
//  RegisterPresenter.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/21/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Firebase

class RegisterPresenterImpl: RegisterPresenter {
    var view: RegisterView?
    
    func attach(view: RegisterView) {
        self.view = view
    }
    
    func dettach(view: RegisterView) {
        if let myView = self.view {
            if myView === view {
                self.view = nil
            }
        }
    }
    
    func register(name: String, email: String, password: String) {
        view?.showProgressHud()
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                self?.view?.showError(error: error.localizedDescription)
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            let ref = Constants.Firebase.databaseRef
            let userReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
            self?.view?.hideProgressHud()
            self?.view?.registerSuccess()
            })
        }
    }
}
