//
//  UserManager.swift
//  BusTrafficDemo
//
//  Created by Aleksandar Jovchevski on 6/21/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation

protocol UserManager {
    func isUserLoggedIn() -> Bool
    
    func logOut()

    //logout will return error if developer calls logout function when user is not actually logged in
    func logOutError() -> Error?
}
