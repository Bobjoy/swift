//
//  BaseViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/19.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

struct BBar {
    var title: String!
    var action: Selector!
    
    init(title: String, action: Selector) {
        self.title = title
        self.action = action
    }
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initNavBar(title: String?, left: UIBarButtonItem?, right: UIBarButtonItem?) {
        //创建一个导航栏
        var navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        //创建一个导航栏集合
        var navItem = UINavigationItem(title: title)
        if let leftBar = left {
            navItem.leftBarButtonItem = leftBar
        }
        if let rightBar = right {
            navItem.rightBarButtonItem = rightBar
        }
        navBar.backgroundColor = UIColor.grayColor()
        navBar.pushNavigationItem(navItem, animated: false)
        self.view.addSubview(navBar)
    }
    
}
