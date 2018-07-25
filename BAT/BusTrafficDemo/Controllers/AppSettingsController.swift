//
//  AppSettingsController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/27/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

class AppSettingsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.colorBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

