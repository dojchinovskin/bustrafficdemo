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


class TimetableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var myTableView: UITableView!
    
    private let stations: Array = ["BUS 1", "BUS 2", "BUS 3", "BUS 4", "BUS 5", "BUS 6", "BUS 7", "BUS 8", "BUS 9", "BUS 10",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        myTableView = UITableView()
        myTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 44
        
        setupView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return stations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.bus.text = "\(stations[indexPath.row])"
        cell.time.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        self.view.addSubview(myTableView)
        self.view.addSubview(closeButton)
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.bottom.equalTo(view).offset(-90)
            make.right.equalTo(view)
            make.left.equalTo(view)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(myTableView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 161, g: 117, b: 170)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        return button
    }()
    
}
