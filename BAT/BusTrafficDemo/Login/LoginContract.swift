//
//  LoginContract.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/9/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

protocol LoginView: class {
    func showWrongEmail()
    func showWrongPassword()
    func loginSuccess()
    func showProgressHud()
    func hideProgressHud()
    func showResetPasswordSuccess(viewController: UIViewController)
    func showResetPasswordFailure(viewController: UIViewController)
    func showConfirmationPassword(viewController: UIViewController)
}

protocol LoginPresenter: class {
    func attach(view: LoginView)
    func dettach(view: LoginView)
    
    func login(email: String, password: String)
    func forgetPassword()
}

