//
//  LoginViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    var onlineUser: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onlineUser = NSMutableArray()
        
        // 设置标题栏
        var closeBtn = UIBarButtonItem(title: "关闭  ", style: .Done, target: self, action: "close")
        self.initNavBar("用户登录", left: nil, right: closeBtn)
        
    }

    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func regist(sender: AnyObject) {
        var usernameField = self.view.viewWithTag(11) as! UITextField
        var passwordField = self.view.viewWithTag(12) as! UITextField
        
        var user = usernameField.text
        var pass = passwordField.text
        
        var xmppHelper = BXMPPHelper.sharedInstance()
        var isConnect = xmppHelper.connect()
        xmppHelper.registerWithJid(user, password: pass) { (isSuccess, error) -> () in
            println(error)
        }
    }

    @IBAction func login(sender: UIButton) {
        var usernameField = self.view.viewWithTag(11) as! UITextField
        var passwordField = self.view.viewWithTag(12) as! UITextField
        var serverField = self.view.viewWithTag(13) as! UITextField
        
        var user = usernameField.text
        var pass = passwordField.text
        var server = serverField.text
        
        if validateWithUser(user, passText: pass, server: server) {
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(user, forKey: "userId")
            defaults.setObject(pass, forKey: "pass")
            defaults.setObject(server, forKey: "server")
            // 保存
            defaults.synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            UIAlertView(title: "错误", message: "账号或密码错误", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func validateWithUser(userText: String, passText: String, server: String) -> Bool {
        if count(userText) > 0 && count(passText) > 0 && count(server) > 0 {
            return true
        }
        return false
    }
}
