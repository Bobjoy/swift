//
//  LoginViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var requireLogin = false
    var onlineUser: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        onlineUser = NSMutableArray()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( sender as? UIBarButtonItem == self.doneButton ) {
            var usernameField = self.view.viewWithTag(11) as! UITextField
            var passwordField = self.view.viewWithTag(12) as! UITextField
            var serverField = self.view.viewWithTag(13) as! UITextField
            
            var user = usernameField.text
            var pass = passwordField.text
            var server = serverField.text
            
            if validateWithUser(user, passText: pass, server: server) {
                var defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(user, forKey: Constant.udUserId)
                defaults.setObject(pass, forKey: Constant.udPass)
                defaults.setObject(server, forKey: Constant.udServer)
                //同步用户配置
                defaults.synchronize()
                //需要登陆
                requireLogin = true
            } else {
                UIAlertView(title: "错误", message: "账号或密码错误", delegate: nil, cancelButtonTitle: "OK").show()
                return
            }
        }
    }
    
    func validateWithUser(userText: String, passText: String, server: String) -> Bool {
        if count(userText) > 0 && count(passText) > 0 && count(server) > 0 {
            return true
        }
        return false
    }
}
