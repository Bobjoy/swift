//
//  PersonViewController.swift
//  BTrip
//
//  Created by Vetech on 15/6/4.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation
import UIKit

class PersonViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let kCellID = "cell"
    
    var mTableView: UITableView!
    var mTableData: [[[String: String]]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "个人中心"
        self.hideNav = true
        
        mTableData = [
            [
                ["title":"订单", "detail":"手机号查订单"]
            ],
            [
                ["title":"钱包", "detail":"现金、礼品卡、返现"],
                ["title":"优惠券", "detail":""],
                ["title":"团购券", "detail":""],
                ["title":"积分", "detail":""]
            ],
            [
                ["title":"常用信息", "detail":"旅客、地址"],
                ["title":"收藏", "detail":""],
                ["title":"一生的旅行", "detail":"旅行足迹"],
                ["title":"更多", "detail":"订阅、设置、关于"]
            ]
        ]
        setupTableView()
    }
    // 组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mTableData.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    // 每组个数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTableData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: kCellID)
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(14)
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let data = mTableData[indexPath.section][indexPath.row]
        cell.textLabel?.text = data["title"]
        cell.detailTextLabel?.text = data["detail"]
        return cell
    }
    
    func setupTableHeaderView() {
        let headerHeight: CGFloat = 150.0
        let buttonWidth: CGFloat = 100.0
        let buttonHeight: CGFloat = 40.0
        
        var header = UIView()
        header.frame.size.height = headerHeight
        header.contentMode = UIViewContentMode.ScaleToFill
        header.backgroundColor = UIColor(patternImage: UIImage(named: "home_bg.png")!)
        // 标题
        var label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        label.text = self.title
        header.addSubview(label)
        // 登陆/注册按钮
        var button = UIButton()
        button.backgroundColor = UIColor.orangeColor()
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitle("登陆/注册", forState: UIControlState.Normal)
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSizeMake(0, 2)
        button.layer.shadowColor = button.backgroundColor!.CGColor
        button.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        button.layer.shadowRadius = 5;//阴影半径，默认3
        button.addTarget(self, action: "loginAction", forControlEvents: UIControlEvents.TouchUpInside)
        header.addSubview(button)
        
        let btnTop = headerHeight/2.0
        let btnLeft = (self.view.frame.width-buttonWidth)/2.0
        autolayout(header, views: ["label":label, "button":button], formats: ["H:|[label]|", "H:|-\(btnLeft)-[button(\(buttonWidth))]", "V:|-16-[label]", "V:|-\(btnTop)-[button(\(buttonHeight))]"])
        
        mTableView.tableHeaderView = header
    }
    
    func setupTableFooterView() {
        var footer = UIView()
        footer.frame.size.height = 60
        footer.contentMode = UIViewContentMode.ScaleToFill
        footer.backgroundColor = UIColor.colorWithHexString("#FFFFFF", alphaValue: 0)
        
        var label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        label.text = "胜意在手，说走就走"
        footer.addSubview(label)
        
        autolayout(footer, views: ["label":label], formats: ["H:|[label]|", "V:|[label]|"])
        
        mTableView.tableFooterView = footer
    }
    
    func setupTableView() {
        mTableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        mTableView.dataSource = self
        mTableView.delegate = self
        
        setupTableHeaderView()
        setupTableFooterView()
        
        self.view.addSubview(mTableView)
        autolayout(self.view, views: ["table":mTableView], formats: ["H:|[table]|", "V:|-20-[table]|"])
    }
    
    func loginAction() {
        var loginCtrl = UIStoryboard(name: "Person", bundle: nil)
            .instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
        self.navigationController?.pushViewController(loginCtrl, animated: false)
    }
}
