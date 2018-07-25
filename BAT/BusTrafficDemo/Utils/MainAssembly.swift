//
//  MainAssemblhy.swift
//  BusTrafficDemo
//
//  Created by Aleksandar Jovchevski on 6/21/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation

class MainAssembly {
    func getGlobalNavigator() -> Navigator {
        return NavigatorImpl()
    }

    func getUserManager() -> UserManager {
        return UserManagerFirebase()
    }
}
