//
//  MainViewController.swift
//  Vetrip
//
//  Created by Vetech on 15/5/21.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import Foundation
import UIKit

class IndexViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, IndexTableCellDelegate{
    
    var mSearchView: UIView!
    //var mScrollView: UIView!
    var mTableView: UITableView!
    
    let kTableCellID : String = "IndexCell"
    
    var mTableCellData = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页"
        self.hideNav = true
        // 初始化数据
        mTableCellData = [
            ["image":"flight.png","l1":"机票","l2":"火车票","l3":"接送机","l4":"汽车票","l5":"自驾・专车","bgcolor":BGColor.blue],
            ["image":"hotel.png","l1":"酒店","l2":"海外","l3":"周边","l4":"团购・特惠","l5":"客栈・公寓","bgcolor":BGColor.red],
            ["image":"travel.png","l1":"旅游","l2":"门票・玩乐","l3":"出境WiFi","l4":"邮轮","l5":"签证","bgcolor":BGColor.green],
            ["image":"local.png","l1":"攻略","l2":"周末游","l3":"礼品卡","l4":"美食・购物","l5":"更多","bgcolor":BGColor.orange]
        ]
        // 初始化视图
        setupSearchView()
        setupTableView()
        // 布局视图
        layoutViews()
        
        //SwifterTips.testGCD()
        //SwifterTips.testUnsafe()
    }
    
    // #pragma MASK - UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTableCellData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = mTableView.dequeueReusableCellWithIdentifier(kTableCellID) as! IndexTableCell
        cell.index = indexPath.row + 1
        cell.delegate = self
        cell.data = mTableCellData[indexPath.row]
        return cell
    }
    
    func setupSearchView() {
        // 设置头部搜索视图
        mSearchView = UIView()
        mSearchView.backgroundColor = UIColor.whiteColor()
        
        var sv = UISearchBar()
        sv.backgroundColor = UIColor.whiteColor()
        
        var iv = UIImageView(image: UIImage(named: "voice.png"))
        
        mSearchView.addSubview(sv)
        mSearchView.addSubview(iv)
        
        let views = ["sv": sv, "iv": iv]
        let formats = ["H:|[sv][iv(==50)]|", "V:|-20-[sv]|", "V:|-20-[iv(==sv)]|"]
        autolayout(mSearchView, views: views, formats: formats)
    }
    
    func setupTableView() {
        mTableView = UITableView()
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.registerNib(UINib(nibName: "IndexTableCell", bundle: nil), forCellReuseIdentifier: kTableCellID)
        mTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //mTableView.backgroundColor = UIColor.magentaColor()
        
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        let headHeight: CGFloat = 15
        
        // 设置头部图片轮播
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        headerView.backgroundColor = UIColor(patternImage:
            self.filledImage(headerView, image: UIImage(named: "home_banner.png"))!)
        mTableView.tableHeaderView = headerView

        // 设置底部视图
        var footerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        footerView.backgroundColor = UIColor(patternImage:
            self.filledImage(footerView, image: UIImage(named: "home_bottom.png"))!)
        mTableView.tableFooterView = footerView
    }
    
    func layoutViews() {
        self.view.addSubview(mSearchView)
        self.view.addSubview(mTableView)
        // 设置自动布局
        let views = ["search": mSearchView, "table": mTableView] as [String:UIView]
        let formats = ["H:|[search]|", "H:|[table]|", "V:|[search(==60)][table]|"]
        autolayout(self.view, views: views, formats: formats)
    }
    
    func monitorAction(sender: UIView?) {
        if let view = sender {
            var nextView: UIViewController!
            switch view.tag {
            case 11:
                nextView = UIStoryboard(name: "Flight", bundle: nil)
                    .instantiateViewControllerWithIdentifier("flightSearch") as! FlightSearchController
                self.navigationController?.pushViewController(nextView, animated: true)
            case 21:
                nextView = UIStoryboard(name: "Hotel", bundle: nil)
                    .instantiateViewControllerWithIdentifier("hotelSearch") as! HotelSearchController
                self.navigationController?.pushViewController(nextView, animated: true)
            default: break
            }
            
            var alert = UIAlertView(frame: CGRectMake(0, 0, 100, 50))
            alert.message = "\(view.tag)"
            alert.show()
            
            var time = dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                alert.dismissWithClickedButtonIndex(0, animated: true)
            })
            
        }
    }
    
}
