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
    func reauthenticateName()
    func resetEmail()
    func reauthenticateEmail()
    func resetPassword()
    func reauthenticatePassword()
    func showUpdate(title: String)
    func showFailure(error: String)
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

