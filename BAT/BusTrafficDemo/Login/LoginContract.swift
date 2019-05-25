//
//  LoginContract.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/9/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

protocol LoginView: class {
    func showError(error: String)
    func loginSuccess()
    func showProgressHud()
    func hideProgressHud()
    func showPasswordResetStatus(message: String)
}

protocol LoginPresenter: class {
    func attach(view: LoginView)
    func dettach(view: LoginView)
    
    func login(email: String, password: String)
    func forgetPassword(email: String)
}

