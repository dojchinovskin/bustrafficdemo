//
//  File.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 6/20/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UINavigationBar {
    func colorBar() {
        self.tintColor = .white
        self.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        self.barTintColor = UIColor(r: 161, g: 117, b: 170)
    }
}




