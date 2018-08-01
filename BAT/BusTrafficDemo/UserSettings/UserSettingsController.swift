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
    
    func changePassword() {
        userSettingsPresenter.resetPassword()
    }
    
    func changeEmail() {
        userSettingsPresenter.resetEmail()
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





