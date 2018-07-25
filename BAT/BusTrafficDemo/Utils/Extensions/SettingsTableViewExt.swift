//
//  SettingsControllerTableViewHelper.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/4/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mycell") else { return UITableViewCell() }
        cell.textLabel?.text = items[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let userSettings = UserSettingsController()
            self.navigationController?.pushViewController(userSettings, animated: true)
        case 1:
            let appSettings = AppSettingsController()
            self.navigationController?.pushViewController(appSettings, animated: true)
        case 2:
            deactivateAccount()
        case 3:
            logOut()
        default:
            print("Nothing selected")
        }
    }
}

