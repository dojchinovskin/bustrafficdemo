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

class UserSettingsController: UIViewController, UserSettingsView {
    private let tableView = UITableView()
    
    var userSettingsPresenter = UserSettingsPresenterImpl()
    let items = ["Edit your name", "Edit your email", "Edit your password"]
    
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
        DispatchQueue.main.async {
            let changeNameAlert = UIAlertController(title: "Edit your name", message: "Enter your email and password", preferredStyle: .alert)
            changeNameAlert.addTextField { (emailTextField) in
                emailTextField.placeholder = "Enter your email"
            }
            changeNameAlert.addTextField { (passwordTextField) in
                passwordTextField.placeholder = "Enter your password"
                passwordTextField.isSecureTextEntry = true
            }
            
            changeNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            changeNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                guard let email = changeNameAlert.textFields?[0].text else { return }
                guard let password = changeNameAlert.textFields?[1].text else { return }
                self.userSettingsPresenter.reauthenticateName(email: email, password: password)
            }))
            self.present(changeNameAlert, animated: true, completion: nil)
        }
    }
    
    func reauthenticateNameSuccess() {
        let newNameAlert = UIAlertController(title: "New Name", message: "Enter your new name", preferredStyle: .alert)
        newNameAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter your new name"
        })
        newNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        newNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let newName = newNameAlert.textFields?.first?.text else { return }
            if newName.isEmpty {
                self.emptyNameTextfield()
                return
            }
            self.userSettingsPresenter.updateName(name: newName)
        }))
        present(newNameAlert, animated: true, completion: nil)
    }
    
    func updateNameSuccess() {
        let newNameSetAlert = UIAlertController(title: "Changed name successfully", message: "Your new name has been set.", preferredStyle: .alert)
        newNameSetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(newNameSetAlert, animated: true, completion: nil)
    }
    
    //MARK: RESET EMAIL
    
    func resetEmail() {
        DispatchQueue.main.async {
            let changeEmailAlert = UIAlertController(title: "Edit your email", message: "Enter your old email and password", preferredStyle: .alert)
            changeEmailAlert.addTextField { (emailTextField) in
                emailTextField.placeholder = "Enter your old email"
            }
            changeEmailAlert.addTextField { (passwordTextField) in
                passwordTextField.placeholder = "Enter your password"
                passwordTextField.isSecureTextEntry = true
            }
            changeEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            changeEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                guard let email = changeEmailAlert.textFields?[0].text else { return }
                guard let password = changeEmailAlert.textFields?[1].text else { return }
                self.userSettingsPresenter.reauthenticateEmail(email: email, password: password)
            }))
            self.present(changeEmailAlert, animated: true, completion: nil)
        }
    }
    
    func reauthenticateEmailSuccess() {
        let newEmailAlert = UIAlertController(title: "New Email", message: "Enter your new email", preferredStyle: .alert)
        newEmailAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter your new email"
        })
        newEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        newEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let newEmail = newEmailAlert.textFields?.first?.text else { return }
            self.userSettingsPresenter.updateEmail(email: newEmail)
        }))
        present(newEmailAlert, animated: true, completion: nil)
    }
    
    func updateEmailSuccess() {
        let resetEmailSentAlert = UIAlertController(title: "Changed email successfully", message: "Your new email has been set.", preferredStyle: .alert)
        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetEmailSentAlert, animated: true, completion: nil)
    }
    
    //MARK: RESET PASSWORD
    
    func resetPassword() {
        DispatchQueue.main.async {
            let changePasswordAlert = UIAlertController(title: "Edit your password", message: "Enter your email and password", preferredStyle: .alert)
            changePasswordAlert.addTextField { (emailTextField) in
                emailTextField.placeholder = "Enter your email"
            }
            changePasswordAlert.addTextField { (passwordTextField) in
                passwordTextField.placeholder = "Enter your password"
                passwordTextField.isSecureTextEntry = true
            }
            changePasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            changePasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                guard let email = changePasswordAlert.textFields?[0].text else { return }
                guard let password = changePasswordAlert.textFields?[1].text else { return }
                self.userSettingsPresenter.reauthenticatePassword(email: email, password: password)
            }))
            self.present(changePasswordAlert, animated: true, completion: nil)
        }
    }
    
    func reauthenticatePasswordSuccess() {
        let newPasswordAlert = UIAlertController(title: "New Password", message: "Enter your new password", preferredStyle: .alert)
        newPasswordAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter your new password"
            textField.isSecureTextEntry = true
        })
        newPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        newPasswordAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let email = newPasswordAlert.textFields?.first?.text else { return }
            self.userSettingsPresenter.updatePassword(email: email)
        }))
        present(newPasswordAlert, animated: true, completion: nil)
    }
    
    func updatePasswordSuccess() {
        let resetPasswordSentAlert = UIAlertController(title: "Changed password successfully", message: "Your new password has been set.", preferredStyle: .alert)
        resetPasswordSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetPasswordSentAlert, animated: true, completion: nil)
    }
    
    //MARK: FAILURES
    
    func reauthenticateFailure(error: Error) {
        let failedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(failedAlert, animated: true, completion: nil)
    }
    
    func updateEmailPasswordFailure(error: Error) {
        let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetFailedAlert, animated: true, completion: nil)
    }
    
    func emptyNameTextfield() {
        let resetFailedAlert2 = UIAlertController(title: "Editing Failed", message: "You didn't submit anything.", preferredStyle: .alert)
        resetFailedAlert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetFailedAlert2, animated: true, completion: nil)
    }
}





