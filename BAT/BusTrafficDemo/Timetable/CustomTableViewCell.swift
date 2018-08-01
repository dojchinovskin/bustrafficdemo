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

class CustomTableViewCell: UITableViewCell {
    
    let img = UIImageView()
    let bus = UILabel()
    let time = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        img.backgroundColor = UIColor.green
        
        contentView.addSubview(img)
        contentView.addSubview(bus)
        contentView.addSubview(time)
        
        img.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.centerY.equalToSuperview()
        }
        
        bus.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        time.snp.makeConstraints { (make) in
            make.right.equalTo(img.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
