//
//  CustomCell.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/31/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TimetableTableViewCell: UITableViewCell {
    let img = UIImageView()
    let busLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        img.backgroundColor = UIColor.green
        
        contentView.addSubview(img)
        contentView.addSubview(busLabel)
        contentView.addSubview(timeLabel)
    }
    
    private func setupConstraints() {
        img.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        busLabel.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
