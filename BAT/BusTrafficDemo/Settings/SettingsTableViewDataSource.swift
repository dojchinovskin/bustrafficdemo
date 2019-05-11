//
//  SettingsControllerTableViewDataSource.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/4/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else { return UITableViewCell() }
        cell.textLabel?.text = items[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let userSettings = UserSettingsViewController()
            self.navigationController?.pushViewController(userSettings, animated: true)
        case 1:
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        case 2:
            deactivateAccount()
        case 3:
            logOut()
        default:
            print("Nothing selected")
        }
    }
}

