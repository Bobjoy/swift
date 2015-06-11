//
//  MainViewController.swift
//  BTrip
//
//  Created by Vetech on 15/6/4.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    var myTabbar: UIView?
    var slider: UIView?
    var itemWith: CGFloat?
    
    let btnBGColor = UIColor(red: 125/255.0, green: 236/255.0, blue: 198/255.0, alpha: 1)
    let tabBarBGColor = UIColor(red: 251/255.0, green: 173/255.0, blue: 69/255.0, alpha: 1)
    
    let itemArray = ["首页", "旅行日程", "客服中心", "个人中心"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // 隐藏导航栏
        self.navigationController?.navigationBarHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置视图
        setupViews()
        // 初始化控制器
        initViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func setupViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        self.tabBar.hidden = true
        self.itemWith = self.view.frame.width/4
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        self.myTabbar = UIView(frame: CGRectMake(0, height-50, width, 50))
        self.myTabbar!.backgroundColor = tabBarBGColor
        self.slider = UIView(frame: CGRectMake(0, 0, itemWith!, 50))
        self.slider!.backgroundColor = UIColor.whiteColor()
        self.slider!.alpha = 0.4
        self.myTabbar!.addSubview(self.slider!)
        self.view.addSubview(self.myTabbar!)
        
        let count = self.itemArray.count
        for index in 0..<count {
            var btnWidth = CGFloat(index) * itemWith!
            var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            button.frame = CGRectMake(btnWidth, 0, itemWith!, 50)
            button.tag = index + 100
            
            var title = self.itemArray[index]
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            button.addTarget(self, action: "switchView:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.myTabbar!.addSubview(button)
            if index == 0 {
                button.selected = true
            }
        }
    }
    
    func initViewControllers() {
        var indexCtrl = IndexViewController()
        var planCtrl = PlanViewController()
        var serviceCtrl = ServiceViewController()
        var personCtrl = PersonViewController()
        self.viewControllers = [indexCtrl, planCtrl, serviceCtrl, personCtrl]
    }

    func switchView(sender: UIButton) {
        var index = sender.tag
        for i in 0..<4 {
            var button = self.view.viewWithTag(i+100) as! UIButton
            if button.tag == index {
                button.selected = true
            }else{
                button.selected = false
            }
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.slider!.frame = CGRectMake(CGFloat(index-100)*self.itemWith!, 0, self.itemWith!, 50)
        })
        
        self.title = itemArray[index-100] as String
        self.selectedIndex = index-100
    }
}
