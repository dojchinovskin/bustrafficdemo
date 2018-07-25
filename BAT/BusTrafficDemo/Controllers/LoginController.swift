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

class LoginController: UIViewController, LoginView, RegisterView {
    
    //MARK: Variables

    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    var loginPresenter: LoginPresenter = LoginPresenterImpl()
    var registerPresenter: RegisterPresenter = RegisterPresenterImpl()
    
    private let navigator: Navigator = MainAssembly().getGlobalNavigator()
    
    let errorEmail = "Wrong Email or Password"
    let errorPassword = "Wrong Email or Password"
    let errorEmailAlreadyUsed = "The email address is already in use by another account."
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(forgetPasswordButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        setupForgetPasswordButton()
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
    
    // MARK: Functions

    func showWrongEmail() {
        SVProgressHUD.showError(withStatus: errorEmail)
    }

    func showWrongPassword() {
        SVProgressHUD.showError(withStatus: errorPassword)
    }

    func loginSuccess() {
        navigator.setHomeScreenAsRootController()
    }

    func showProgressHud() {
        SVProgressHUD.show()
    }

    func hideProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    func showEmailAlreadyUsed() {
        SVProgressHUD.showError(withStatus: errorEmailAlreadyUsed)
    }
    
    func registerSuccess() {
        navigator.setHomeScreenAsRootController()
    }
    
    func presentAlerts(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    //MARK: Handling Buttons
    
    @objc func pressedLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        loginPresenter.login(email: email, password: password)       
    }
    
    @objc func pressedRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        registerPresenter.register(name: name, email: email, password: password)
    }

    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == AuthType.login.rawValue {
            pressedLogin()
        } else {
            pressedRegister()
        }
    }
    
    @objc func forgetPassword() {
        loginPresenter.forgetPassword()
    }

    //MARK: Setup Views
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            inputsContainerViewHeightAnchor?.constant = 100
            forgetPasswordButton.isHidden = false

        } else {
            inputsContainerViewHeightAnchor?.constant = 150
            forgetPasswordButton.isHidden = true
        }
        
        let loginVisible = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        updateTextFields(loginVisible: loginVisible)
        
    }
    
    private func updateTextFields(loginVisible: Bool) {
        // change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginVisible ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginVisible ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginVisible ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    let forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forget your password?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
        button.isHidden = true

        return button
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true

        return view
    }()

    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false

        return tf
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false

        return tf
    }()

    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true

        return tf
    }()

    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)

        return sc
    }()
    
    func setupForgetPasswordButton(){
        forgetPasswordButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginRegisterButton.snp.bottom)
            make.leading.equalTo(inputsContainerView.snp.leading)
            make.height.equalTo(40)
        }
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(inputsContainerView.snp.top).offset(-12)
            make.width.equalTo(inputsContainerView)
            make.height.equalTo(36)
        }
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(inputsContainerView.snp.bottom).offset(12)
            make.width.equalTo(inputsContainerView.snp.width)
            make.height.equalTo(50)
        }
    }
    
    func setupInputsContainerView() {
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        inputsContainerView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(view).offset(-24)
        }
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(inputsContainerView.snp.leading).offset(12)
            make.top.equalTo(inputsContainerView.snp.top)
            make.width.equalTo(inputsContainerView.snp.width)
        }
        
        nameSeparatorView.snp.makeConstraints { (make) in
            make.leading.equalTo(inputsContainerView.snp.leading)
            make.top.equalTo(nameTextField.snp.bottom)
            make.width.equalTo(inputsContainerView.snp.width)
            make.height.equalTo(1)
        }
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        emailTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(inputsContainerView.snp.leading).offset(12)
            make.top.equalTo(nameSeparatorView.snp.top)
            make.width.equalTo(inputsContainerView.snp.width)
        }
        
        emailSeparatorView.snp.makeConstraints { (make) in
            make.leading.equalTo(inputsContainerView.snp.leading)
            make.top.equalTo(emailTextField.snp.bottom)
            make.width.equalTo(inputsContainerView.snp.width)
            make.height.equalTo(1)
        }
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        passwordTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(inputsContainerView.snp.leading).offset(12)
            make.top.equalTo(emailSeparatorView.snp.top)
            make.width.equalTo(inputsContainerView.snp.width)
        }
        
    }
    

}