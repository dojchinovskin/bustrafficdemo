//
//  FirebaseUserManager.swift
//  BusTrafficDemo
//
//  Created by Aleksandar Jovchevski on 6/21/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserManagerFirebase: UserManager {

    public func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    public func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }

    public func logOutError() -> Error? {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            return logoutError
        }
        return nil
    }
}
