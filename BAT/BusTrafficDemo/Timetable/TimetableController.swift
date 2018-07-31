//
//  TimetableController.swift
//  BusTrafficDemo
//
//  Created by Nikola Dojchinovski on 7/30/18.
//  Copyright © 2018 Nikola Dojchinovski. All rights reserved.
//

import Foundation
import UIKit


class TimetableController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var myTableView: UITableView!
    
    private let sections: NSArray = ["fruit", "vegitable"]    //Profile    network    audio Codecs
    private let fruit: NSArray = ["apple", "orange", "banana", "strawberry", "lemon"]
    private let vegitable: NSArray = ["carrots", "avocado", "potato", "onion"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get width and height of View
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - (barHeight)))
        myTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")         // register cell name
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 44
        
        self.view.addSubview(myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // return the number of sections
    func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    
    
    // return the title of sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as? String
    }
    
    
    // called when the cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Num: \(indexPath.row)")
        if indexPath.section == 0 {
            print("Value: \(fruit[indexPath.row])")
        } else if indexPath.section == 1 {
            print("Value: \(vegitable[indexPath.row])")
        }
    }
    
    // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return fruit.count
        } else if section == 1 {
            return vegitable.count
        } else {
            return 0
        }
    }
    
    // return cells
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        if indexPath.section == 0 {
            cell.labUerName.text = "\(fruit[indexPath.row])"
            cell.labMessage.text = "Message \(indexPath.row)"
            cell.labTime.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short)
        } else if indexPath.section == 1 {
            cell.labUerName.text = "\(vegitable[indexPath.row])"
            cell.labMessage.text = "Message \(indexPath.row)"
            cell.labTime.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short)
        }
        
        
        
        return cell
    }
    
}
