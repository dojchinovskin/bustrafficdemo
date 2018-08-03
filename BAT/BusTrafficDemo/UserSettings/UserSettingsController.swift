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
    func reathenticateEmailSuccess() {
        let newEmailAlert = UIAlertController(title: "New Email", message: "Enter your new email", preferredStyle: .alert)
        newEmailAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter your new email"
        })
        newEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        newEmailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            guard let newEmail = newEmailAlert.textFields?.first?.text else { return }
            self.userSettingsPresenter.updateEmail(email: newEmail)
        }))
    }
    
    func reathenticatePasswordFailure(error: Error) {
        print(123)
    }
    
    func updateEmailSuccess() {
        let resetEmailSentAlert = UIAlertController(title: "Changed email successfully", message: "Your new email has been set.", preferredStyle: .alert)
        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetEmailSentAlert, animated: true, completion: nil)
    }
    
    func updateEmailFailure(error: Error) {
        let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetFailedAlert, animated: true, completion: nil)
    }
    
    
    func updatePasswordSuccess() {
        let resetPasswordSentAlert = UIAlertController(title: "Changed password successfully", message: "Your new password has been set.", preferredStyle: .alert)
        resetPasswordSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetPasswordSentAlert, animated: true, completion: nil)
    }
    
    func updatePasswordFailure(error: Error) {
        let resetFailedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetFailedAlert, animated: true, completion: nil)
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
    
    func reauthenticateFailure(error: Error) {
        let failedAlert = UIAlertController(title: "Editing Failed", message: error.localizedDescription, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(failedAlert, animated: true, completion: nil)
    }
    
    func resetPassword() {
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
            self.userSettingsPresenter.reauthenticate(email: email, password: password)
        }))
        present(changePasswordAlert, animated: true, completion: nil)
    }
    
    func resetEmail() {
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
            self.userSettingsPresenter.reauthenticate(email: email, password: password)
        }))
        present(changeEmailAlert, animated: true, completion: nil)
    }
    
    var userSettingsPresenter = UserSettingsPresenterImpl()
    let items = ["Edit your name", "Edit your email", "Edit your password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
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
    
    func changeName() {
        userSettingsPresenter.resetName()
    }
    
    func showProgressHud() {
        SVProgressHUD.show()
    }
    
    func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    func presentAlert(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var inputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tv.isScrollEnabled = false
        return tv
    }()
    
    func setupViews() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.colorBar()
        navigationItem.title = "User Settings"
        
        view.addSubview(inputsContainerView)
        setupConstraints()
    }
    
    func setupConstraints() {
        // SAFEAREALAYOUT
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        
        inputsContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(navigationBarHeight)
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(inputsContainerView)
        }
    }
}





