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
    func resetName()
    func reauthenticateNameSuccess()
    func updateNameSuccess()
    func emptyNameTextfield()
    func resetEmail()
    func reauthenticateEmailSuccess()
    func updateEmailSuccess()
    func resetPassword()
    func reauthenticatePasswordSuccess()
    func updatePasswordSuccess()
    func updateEmailPasswordFailure(error: Error)
    func reauthenticateFailure(error: Error)
}

protocol UserSettingsPresenter: class {
    func attach(view: UserSettingsView)
    func dettach(view: UserSettingsView)
    
    func reauthenticatePassword(email: String, password: String)
    func reauthenticateEmail(email: String, password: String)
    func reauthenticateName(email: String, password: String)
    func updatePassword(email: String)
    func updateEmail(email: String)
    func updateName(name: String)
}

