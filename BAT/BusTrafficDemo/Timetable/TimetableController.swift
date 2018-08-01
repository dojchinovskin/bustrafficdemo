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
    
    private let stations: Array = ["BUS 1", "BUS 2", "BUS 3", "BUS 4", "BUS 5", "BUS 6", "BUS 7", "BUS 8", "BUS 9", "BUS 10",]
    
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
    
    // called when the cell is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
    }
    
    // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return stations.count
    }
    
    // return cells
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.bus.text = "\(stations[indexPath.row])"
        cell.time.text = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .short, timeStyle: .short)
        
        return cell
    }
    
}
