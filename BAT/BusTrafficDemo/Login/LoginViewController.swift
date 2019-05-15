//
//  LoginController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/20/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SnapKit

enum AuthType: Int {
    case login = 0
    case signup = 1
}

class LoginViewController: UIViewController, LoginView, RegisterView, UITextFieldDelegate {
    private let inputContainerView = InputContainerView()
    private let forgetPassButton = UIButton(type: .custom)
    private let loginButton = UIButton(type: .custom)
    private let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
    
    var loginPresenter: LoginPresenter = LoginPresenterImpl()
    var registerPresenter: RegisterPresenter = RegisterPresenterImpl()
    
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    let errorEmail = "Wrong Email or Password"
    let errorPassword = "Wrong Email or Password"
    let errorEmailAlreadyUsed = "The email address is already in use by another account."
    
    //MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkInternetConnection()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loginPresenter.attach(view: self)
        registerPresenter.attach(view: self)
        navigationController?.isNavigationBarHidden = true

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        loginPresenter.dettach(view: self)
        registerPresenter.dettach(view: self)
        navigationController?.isNavigationBarHidden = false
    }

    deinit {
        loginPresenter.dettach(view: self)
        registerPresenter.dettach(view: self)
    }
    
    func loginSuccess() {
        navigator.setHomeScreenAsRootController()
    }
    
    func registerSuccess() {
        navigator.setHomeScreenAsRootController()
    }
    
    // MARK: SVPROGRESS ALERTS

    func showWrongEmail() {
        SVProgressHUD.showError(withStatus: errorEmail)
    }

    func showWrongPassword() {
        SVProgressHUD.showError(withStatus: errorPassword)
    }
    
    func showEmailAlreadyUsed() {
        SVProgressHUD.showError(withStatus: errorEmailAlreadyUsed)
    }

    //MARK: PROGRESS HUD

    func showProgressHud() {
        SVProgressHUD.show()
    }

    func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    //MARK: RESET PASSWORD
    
    func showResetPasswordSuccess() {
        let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetEmailSentAlert, animated: true, completion: nil)
    }
    
    func showResetPasswordFailure(error: Error) {
        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(resetFailedAlert, animated: true, completion: nil)
    }
    
    //MARK: CHECK INTERNET CONNECTION
    
    func checkInternetConnection() {
        if !Reachability.isConnectedToNetwork()  {
            let noNetAlert = UIAlertController(title: "No Internet Connection", message: "Connect your phone to internet connections before using this app.", preferredStyle: .alert)
            noNetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                exit(1)
            }))
            present(noNetAlert, animated: true, completion: nil)
        }
        // find a better way for this
    }
    
    //MARK: BUTTONS
    
    @objc func pressedLogin() {
        guard let email = inputContainerView.emailTextfield.text,
            let password = inputContainerView.passwordTextfield.text else { return }
        loginPresenter.login(email: email, password: password)       
    }
    
    @objc func pressedRegister() {
        guard let email = inputContainerView.emailTextfield.text,
            let password = inputContainerView.passwordTextfield.text,
            let name = inputContainerView.nameTextfield.text else { return }
        registerPresenter.register(name: name, email: email, password: password)
    }

    @objc func handleLoginRegister() {
        segmentedControl.selectedSegmentIndex == AuthType.login.rawValue
            ? pressedLogin() : pressedRegister()
    }
    
    @objc func forgetPasswordPressed() {
        let forgotPasswordAlert = UIAlertController(title: "Are you sure you want to reset your password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter your email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (action) in
            guard let resetEmail = forgotPasswordAlert.textFields?.first?.text else { return }
            self?.loginPresenter.forgetPassword(email: resetEmail)
        }))
        present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @objc func handleLoginRegisterChange() {
        let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        loginButton.setTitle(title, for: .normal)
        
        let isLoginPressed = segmentedControl.selectedSegmentIndex == 0
        inputContainerView.updateConstraints(isLoginPressed)
        inputContainerView.snp.updateConstraints { (update) in
            update.height.equalTo(isLoginPressed ? 100 : 150)
        }
        forgetPassButton.isHidden = isLoginPressed ? false : true
    }

    //MARK: SETUP VIEWS
    
    func setupViews() {
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        
        loginButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        forgetPassButton.setTitle("Forget your password?", for: .normal)
        forgetPassButton.setTitleColor(.white, for: .normal)
        forgetPassButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        forgetPassButton.addTarget(self, action: #selector(forgetPasswordPressed), for: .touchUpInside)
        
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        inputContainerView.emailTextfield.delegate = self
        inputContainerView.passwordTextfield.delegate = self
        inputContainerView.nameTextfield.delegate = self
        
        view.addSubview(loginButton)
        view.addSubview(segmentedControl)
        view.addSubview(forgetPassButton)
        view.addSubview(inputContainerView)
    }
    
    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(inputContainerView.snp.top).offset(-15)
            make.width.equalTo(self.view).offset(-15)
            make.height.equalTo(36)
        }
        
        inputContainerView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(100)
            make.width.equalTo(segmentedControl)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(inputContainerView.snp.bottom).offset(15)
            make.width.equalTo(inputContainerView.snp.width)
            make.height.equalTo(50)
        }
        
        forgetPassButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom)
            make.left.equalTo(inputContainerView.snp.left)
            make.height.equalTo(40)
        }
    }
}
