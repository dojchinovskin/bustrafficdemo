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
    private let loginContainerView = LoginContainerView()
    
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
        guard let email = loginContainerView.inputContainerView.emailTextfield.text,
            let password = loginContainerView.inputContainerView.passwordTextfield.text else { return }
        loginPresenter.login(email: email, password: password)       
    }
    
    @objc func pressedRegister() {
        guard let email = loginContainerView.inputContainerView.emailTextfield.text,
            let password = loginContainerView.inputContainerView.passwordTextfield.text,
            let name = loginContainerView.inputContainerView.nameTextfield.text else { return }
        registerPresenter.register(name: name, email: email, password: password)
    }

    @objc func handleLoginRegister() {
        loginContainerView.segmentedControl.selectedSegmentIndex == AuthType.login.rawValue
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
        let title = loginContainerView.segmentedControl.titleForSegment(at: loginContainerView.segmentedControl.selectedSegmentIndex)
        loginContainerView.loginButton.setTitle(title, for: .normal)
        
        let isLoginPressed = loginContainerView.segmentedControl.selectedSegmentIndex == 0
        loginContainerView.inputContainerView.updateConstraints(isLoginPressed)
        loginContainerView.inputContainerView.snp.updateConstraints { (update) in
            update.height.equalTo(isLoginPressed ? 100 : 150)
        }
        loginContainerView.forgetPassButton.isHidden = isLoginPressed ? false : true
    }

    //MARK: SETUP VIEWS
    
    func setupViews() {
        self.hideKeyboardWhenTappedAround()
        
        loginContainerView.inputContainerView.emailTextfield.delegate = self
        loginContainerView.inputContainerView.passwordTextfield.delegate = self
        loginContainerView.inputContainerView.nameTextfield.delegate = self
        
        loginContainerView.loginButton.addTarget(self,
                                                 action: #selector(handleLoginRegister),
                                                 for: .touchUpInside)
        loginContainerView.forgetPassButton.addTarget(self,
                                                      action: #selector(forgetPasswordPressed),
                                                      for: .touchUpInside)
        loginContainerView.segmentedControl.addTarget(self,
                                                      action: #selector(handleLoginRegisterChange),
                                                      for: .valueChanged)
        
        view.addSubview(loginContainerView)
    }
    
    private func setupConstraints() {
        loginContainerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}
