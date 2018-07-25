//
//  RegisterContract.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/9/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

protocol RegisterView: class {
    func registerSuccess()
    func showProgressHud()
    func hideProgressHud()
    func showEmailAlreadyUsed()
}

protocol RegisterPresenter: class {
    func attach(view: RegisterView)
    func dettach(view: RegisterView)
    
    func register(name: String, email: String, password: String)
}
