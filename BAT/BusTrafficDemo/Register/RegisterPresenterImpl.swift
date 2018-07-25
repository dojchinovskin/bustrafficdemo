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
    
    let errorEmailAlreadyUsed = "The email address is already in use by another account."
    
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
            self?.view?.hideProgressHud()
            if error != nil {
                print(error!)
                if error?.localizedDescription == self?.errorEmailAlreadyUsed {
                    self?.view?.showEmailAlreadyUsed()
                }
                return
            }
            guard let uid = user?.user.uid else {
                return
            }
            let ref = Database.database().reference(fromURL: "https://busartrafficdemo.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
            self?.view?.registerSuccess()
            })
        }
    }
}
