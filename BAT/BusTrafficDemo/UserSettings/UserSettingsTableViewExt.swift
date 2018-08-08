//
//  UserSettingsTableViewHelper.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/5/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

extension UserSettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else { return UITableViewCell() }
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            resetName()
        case 1:
            resetEmail()
        case 2:
            resetPassword()
        default:
            print("Nothing selected")
        }
    }
}


