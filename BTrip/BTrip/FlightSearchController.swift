//
//  FlightSearchController.swift
//  BTrip
//
//  Created by Vetech on 15/6/8.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class FlightSearchController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mTableView: UITableView!
    
    let cellID = "flightSearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "机票查询"
        self.hideNav = false
        self.mTableView.registerNib(UINib(nibName: "FlightSearchCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = mTableView.dequeueReusableCellWithIdentifier(cellID) as! FlightSearchCell
        cell.margin = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 8)
        cell.accessory = true
        cell.radius = 10
        cell.bgColor = UIColor.blueColor()
        cell.setNeedsDisplay()
        return cell
    }

}
