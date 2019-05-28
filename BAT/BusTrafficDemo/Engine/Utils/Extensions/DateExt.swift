//
//  DateExt.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 105//19.
//  Copyright © 2019 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var afterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: self)!
    }
    var afterAfterTomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 3, to: self)!
    }
}

