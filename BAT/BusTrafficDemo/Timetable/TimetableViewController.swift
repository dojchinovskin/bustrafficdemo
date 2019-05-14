//
//  TimetableController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/30/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class TimetableViewController: UIViewController {
    private var tableView: UITableView!
    private var closeButton: UIButton!
    
    var lines: [Line]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .white

        tableView = UITableView()
        tableView.register(TimetableTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.dataSource = self
        tableView.delegate = self
        
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "XButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-30)
            make.height.width.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(closeButton.snp.top)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension TimetableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? TimetableTableViewCell else { return UITableViewCell() }
        cell.busLabel.text = lines[indexPath.row].bus
        cell.timeLabel.text = lines[indexPath.row].time
        return cell
    }
}
