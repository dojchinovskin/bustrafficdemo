//
//  SettingsController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/2/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SVProgressHUD

class SettingsController: UIViewController, SettingsView  {
    
    private let userManager: UserManager = MainAssembly().getUserManager()
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    var settingsPresenter = SettingsPresenterImpl()
    
    let items = ["User Settings", "Application Settings", "Deactivate", "Log Out"]
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsPresenter.attach(view: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        settingsPresenter.dettach(view: self)
    }
    
    deinit {
        settingsPresenter.dettach(view: self)
    }
    
    //MARK: PROGRESS HUD
    
    func showProgressHud() {
        SVProgressHUD.show()
    }
    
    func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    //MARK: DEACTIVATE
    
    func deactivateAccount() {
        DispatchQueue.main.async {
            let deleteAccAlert = UIAlertController(title: "Deactivate your account", message: "Enter your email and password", preferredStyle: .alert)
            deleteAccAlert.addTextField { (emailTextField) in
                emailTextField.placeholder = "Enter your email"
            }
            deleteAccAlert.addTextField { (passwordTextField) in
                passwordTextField.placeholder = "Enter your password"
                passwordTextField.isSecureTextEntry = true
            }
            deleteAccAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            deleteAccAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                guard let email = deleteAccAlert.textFields?[0].text else { return }
                guard let password = deleteAccAlert.textFields?[1].text else { return }
                self?.settingsPresenter.deactivateAccount(email: email, password: password)
            }))
            self.present(deleteAccAlert, animated: true, completion: nil)
        }
    }
    
    func showAccountDeactivationSuccess() {
        let removeDatAlert = UIAlertController(title: "Deactivate Your Account", message: "Your account has been deactivated.", preferredStyle: .alert)
        removeDatAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
            self?.showLoginScreen()
            self?.userManager.logOut()
        }))
        present(removeDatAlert, animated: true, completion: nil)
    }
    
    func showAccountDeactivationFailure(error: Error) {
        let failedAlert = UIAlertController(title: "Failed To Deactivate", message: error.localizedDescription, preferredStyle: .alert)
        failedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(failedAlert, animated: true, completion: nil)
    }
    
    //MARK: LOGOUT
    
    func logOut() {
        DispatchQueue.main.async {
            let logOutAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            logOutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                self.settingsPresenter.logOut()
            }))
            logOutAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(logOutAlert, animated: true, completion: nil)
        }
    }
    
    private func showLoginScreen() {
        navigator.setLoginScreenAsRootController()
    }
    
    // MARK: SETUP VIEWS
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "mycell")
        tv.isScrollEnabled = false
        return tv
    }()
    
    lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "user-icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.colorBar()
        navigationItem.title = "Settings"
        
        view.addSubview(inputsContainerView)
        view.addSubview(profileImageView)
        setupConstraints()
        setupImage()
    }
    
    func setupImage() {
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(100)
            make.centerX.equalTo(view)
            make.bottom.equalTo(inputsContainerView.snp.top)
            make.width.height.equalTo(150)
        }
    }
    
    func setupConstraints() {
        inputsContainerView.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(view)
            make.top.equalTo(profileImageView.snp.bottom)
            make.height.equalTo(200)
        }
        
        inputsContainerView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


