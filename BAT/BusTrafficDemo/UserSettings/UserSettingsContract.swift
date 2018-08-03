//
//  UserSettingsContract.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/9/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

protocol UserSettingsView: class {
    func showProgressHud()
    func hideProgressHud()
    func presentAlert(viewController: UIViewController)
    func updateEmailSuccess()
    func updateEmailFailure(error: Error)
    func updatePasswordSuccess()
    func updatePasswordFailure(error: Error)
    func reauthenticatePasswordSuccess()
    func reathenticateEmailSuccess()
    func reauthenticateFailure(error: Error)
    
}

protocol UserSettingsPresenter: class {
    func attach(view: UserSettingsView)
    func dettach(view: UserSettingsView)
    
    //func resetPassword()
    //func resetEmail()
    func resetName()
    func reauthenticate(email: String, password: String)
    func updatePassword(email: String)
    func updateEmail(email: String)
}

