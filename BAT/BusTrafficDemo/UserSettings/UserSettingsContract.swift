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
}

protocol UserSettingsPresenter: class {
    func attach(view: UserSettingsView)
    func dettach(view: UserSettingsView)
    
    func resetPassword()
    func resetEmail()
    func resetName()
}

