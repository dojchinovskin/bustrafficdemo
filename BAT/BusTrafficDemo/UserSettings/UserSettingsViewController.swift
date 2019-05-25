//
//  UserSettingsController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/27/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SVProgressHUD

class UserSettingsViewController: UIViewController, UserSettingsView {
    private let tableView = UITableView()
    
    var userSettingsPresenter = UserSettingsPresenterImpl()
    let items = ["Change your name", "Change your email", "Change your password"]
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "User Settings"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.isScrollEnabled = false
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(items.count * 44)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userSettingsPresenter.attach(view: self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        userSettingsPresenter.dettach(view: self)
    }
    
    deinit {
        userSettingsPresenter.dettach(view: self)
    }
    
    //MARK: PROGRESS HUD
    
    func showProgressHud() {
        SVProgressHUD.show()
    }
    
    func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    //MARK: RESET NAME
    
    func resetName() {
        let alert = self.customAlert(title: "Edit your name",
                                     message: "Enter your email and password",
                                     firstPlaceholder: "Enter your email",
                                     secondPlaceholder: "Enter your password")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let email = alert.textFields?[0].text else { return }
            guard let password = alert.textFields?[1].text else { return }
            self.userSettingsPresenter.reauthenticateName(email: email, password: password)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func reauthenticateName() {
        let alert = self.customAlert(title: "New Name",
                                     message: "Enter your new name",
                                     firstPlaceholder: "Enter your new name",
                                     secondPlaceholder: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let newName = alert.textFields?.first?.text else { return }
            if newName.isEmpty {
                self.showFailure(error: "You didn't submit anything.")
                return
            }
            self.userSettingsPresenter.updateName(name: newName)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: RESET EMAIL
    
    func resetEmail() {
        let alert = self.customAlert(title: "Change your email",
                                     message: "Enter your old email and password",
                                     firstPlaceholder: "Enter your old email",
                                     secondPlaceholder: "Enter your password")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let email = alert.textFields?[0].text else { return }
            guard let password = alert.textFields?[1].text else { return }
            self.userSettingsPresenter.reauthenticateEmail(email: email, password: password)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }    }
    
    func reauthenticateEmail() {
        let alert = self.customAlert(title: "New Email",
                                     message: "Enter your new email",
                                     firstPlaceholder: "Enter your new email",
                                     secondPlaceholder: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let newEmail = alert.textFields?.first?.text else { return }
            self.userSettingsPresenter.updateEmail(email: newEmail)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: RESET PASSWORD
    
    func resetPassword() {
        let alert = self.customAlert(title: "Change your password",
                                     message: "Enter your email and password",
                                     firstPlaceholder: "Enter your email",
                                     secondPlaceholder: "Enter your password")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let email = alert.textFields?[0].text else { return }
            guard let password = alert.textFields?[1].text else { return }
            self.userSettingsPresenter.reauthenticatePassword(email: email, password: password)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }    }
    
    func reauthenticatePassword() {
        let alert = self.customAlert(title: "New password",
                                     message: "Enter your new password",
                                     firstPlaceholder: nil,
                                     secondPlaceholder: "Enter your new password")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let email = alert.textFields?.first?.text else { return }
            self.userSettingsPresenter.updatePassword(email: email)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Update
    
    func showUpdate(title: String) {
        let alert = UIAlertController(title: "Changed \(title) successfully",
            message: "Your new \(title) has been set.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Failure
    
    func showFailure(error: String) {
        let alert = UIAlertController(title: "Changing failed",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UserSettingsViewController {
    private func customAlert(title: String, message: String, firstPlaceholder: String?, secondPlaceholder: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let first = firstPlaceholder {
            alert.addTextField { (textfield) in
                textfield.placeholder = first
                textfield.keyboardType = .emailAddress
            }
        }
        if let second = secondPlaceholder {
            alert.addTextField { (textfield) in
                textfield.placeholder = second
                textfield.isSecureTextEntry = true
            }
        }
        return alert
    }
}





