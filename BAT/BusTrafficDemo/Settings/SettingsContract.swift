//
//  SettingsContract.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/9/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

protocol SettingsView: class {
    func showProgressHud()
    func hideProgressHud()
    func deactivateAccount()
    func showSuccess()
    func showFailure(error: Error)
}

protocol SettingsPresenter: class {
    func attach(view: SettingsView)
    func dettach(view: SettingsView)
    
    func deactivateAccount(email: String, password: String)
    func logOut() 
}
