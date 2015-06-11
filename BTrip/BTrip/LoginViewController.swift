//
//  LoginViewController.swift
//  BTrip
//
//  Created by Vetech on 15/6/5.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController, BSOAPHelperDelegate {

    @IBOutlet var mTableView: UITableView!
    
    let cellIds = ["nameCell", "passCell"]
    let notiName = "login"
    
    var mLoading: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "登录"
        self.view.backgroundColor = UIColor.whiteColor()
        
        setupTableView()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = mTableView.dequeueReusableCellWithIdentifier(cellIds[indexPath.row], forIndexPath: indexPath) as! UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func setupTableView() {
        mTableView.rowHeight = UITableViewAutomaticDimension
        mTableView.backgroundColor = UIColor.colorWithHexString("#F2F2F2")
        
        var header = UIView()
        header.frame.size.height = 16
        header.backgroundColor = UIColor.whiteColor()
        
        mTableView.tableHeaderView = header
        
        
        var footer = UIView()
        footer.frame.size.height = 100
        
        var button = UIButton()
        button.backgroundColor = UIColor.orangeColor()
        button.setTitle("登录", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.addTarget(self, action: "login", forControlEvents: UIControlEvents.TouchUpInside)
        footer.addSubview(button)
        
        let views = ["btn": button]
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        footer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[btn]-16-|", options: nil, metrics: nil, views: views))
        footer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-16-[btn(40)]", options: nil, metrics: nil, views: views))
        
        mTableView.tableFooterView = footer
    }
    
    func startLoading(){
        mLoading = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.WhiteLarge)
        //创建一个UIActivityIndicatorView对象：_activityIndicatorView，并初始化风格。
        let screenSize = UIScreen.mainScreen().bounds.size
        //mLoading!.frame = CGRectMake(screenSize.width/2 - 45/2, screenSize.height/2 - 45/2, 45, 45)
        mLoading!.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        //设置对象的位置，大小是固定不变的。WhiteLarge为37 * 37，White为20 * 20
        mLoading!.color = UIColor.blackColor()
        mLoading!.backgroundColor = UIColor.grayColor()
        //mLoading!.layer.cornerRadius = 25
        mLoading!.layer.masksToBounds = true
        mLoading!.alpha = 0.3
        
        //设置活动指示器的颜色
        mLoading!.hidesWhenStopped = true
        //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
        self.view.addSubview(mLoading!)
        //将对象加入到view
        //mLoading.release();
        //要记得将对象release
        mLoading!.startAnimating();
        
    }
    
    func login() {
        var nameView = mTableView.viewWithTag(111)
        var passView = mTableView.viewWithTag(112)
        if let nameField = nameView, passField = passView {
            // 获取文本
            var name = (nameField as! UITextField).text
            var pass = (passField as! UITextField).text
            // 隐藏键盘
            (nameField as! UITextField).resignFirstResponder()
            (passField as! UITextField).resignFirstResponder()
            // 去空格
            name = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            pass = pass.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            // 判断空值
            if name.isEmpty {
                UIAlertView(title: "错误", message: "帐号不能为空", delegate: self, cancelButtonTitle: "确定").show()
                return
            }else if pass.isEmpty {
                UIAlertView(title: "错误", message: "密码不能为空", delegate: self, cancelButtonTitle: "确定").show()
                return
            }
        
            var requestDict = Dictionary<String, String>()
            requestDict.updateValue("2", forKey: "responseDataType")
            requestDict.updateValue("2", forKey: "version")
            requestDict.updateValue("7", forKey: "websiteCode")
            requestDict.updateValue("\(name)", forKey: "username")
            requestDict.updateValue("\(pass.md5()!)", forKey: "password")
            
            var requestXml = BXMLHelper.toXML("request", dictionary: requestDict)
            //println("请求参数：\n\(requestXml)")
            //println("===============================")
            var helper = BSOAPHelper()
            helper.delegate = self
            helper.beforeRequest(startLoading).member("loginWithMD5", request: requestXml)
        }
    }
    
    func completeRequest(data: NSString, error: NSError?) {
        if error == nil {
            var jsonDict = NSJSONSerialization.JSONObjectWithData(data.dataUsingEncoding(NSUTF8StringEncoding)!,
                options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            if let result = jsonDict!["Res"] as? NSDictionary where jsonDict != nil {
                if let msg: AnyObject = result.objectForKey("message"){
                    UIAlertView(title: "登录失败", message: (msg as! String), delegate: self, cancelButtonTitle: "确定").show()
                }else{
                    UIAlertView(title: "成功", message: "登录成功", delegate: self, cancelButtonTitle: "确定").show()
                    storeUser(result)
                }
            }
        }else{
            UIAlertView(title: "失败", message: "登录失败[\(error!.localizedDescription)]", delegate: self, cancelButtonTitle: "确定").show()
        }
        mLoading?.stopAnimating()
    }
    
    func storeUser(dict: NSDictionary) {
        var userDefault: NSUserDefaults = NSUserDefaults(suiteName: "vemember")!
        
    }

}
