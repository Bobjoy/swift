//
//  MainViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, BChatDelegate {

    @IBOutlet var tbView: UITableView!
    
    private var mOnlineUsers: NSMutableArray!
    private var mChatUserName: String!
    private var mXmppStream: XMPPStream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化数组
        mOnlineUsers = NSMutableArray()
        // UITableView的数据源和代理
        tbView.delegate = self
        tbView.dataSource = self
        // 设定在线用户委托
        var delegate: AppDelegate = self.appDelegate()
        delegate.chatDelegate = self
        // 设置标题栏
        var loginBar = UIBarButtonItem(title: "登录  ", style: .Done, target: self, action: "account")
        self.initNavBar("好友列表", left: nil, right: loginBar)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        var login = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String
        if login != nil {
            if self.appDelegate().connect() {
                NSLog("show buddy list")
            }
        } else {
            var alert = UIAlertView(title: "提示", message: "您还没有设置账号", delegate: self, cancelButtonTitle: "设置")
            alert.show()
        }
    }
    
    // MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.account()
        }
    }
    
    @IBAction func account() {
        self.performSegueWithIdentifier("login", sender: self)
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mOnlineUsers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellid = "userItem"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellid, forIndexPath: indexPath) as! UITableViewCell
        if cell == NSNull() {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellid)
        }
        cell.textLabel?.text = mOnlineUsers.objectAtIndex(indexPath.row) as? String
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mChatUserName = mOnlineUsers.objectAtIndex(indexPath.row) as! String
        self.performSegueWithIdentifier("chat", sender: self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! as NSString).isEqualToString("chat") {
            var chatView = segue.destinationViewController as! ChatViewController
            chatView.chatWithUser = mChatUserName
        }
    }
    
    //MARK: - BChatDegate
    
    /**
    在线好友
    
    :param: buddyName
    */
    func newBuddyOnline(buddyName: String) {
        println("在线好友：\(buddyName)")
        if !mOnlineUsers.containsObject(buddyName) {
            mOnlineUsers.addObject(buddyName)
            self.tbView.reloadData()
        }
    }
    
    /**
    好友下线
    
    :param: buddyName
    */
    func buddyWentOffline(buddyName: String) {
        println("离线好友：\(buddyName)")
        
        mOnlineUsers.removeObject(buddyName)
        self.tbView.reloadData()
    }
    
    func didDisconnect() {
        println("失去连接")
    }
    
    /**
    *  取得当前程序的委托
    */
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    /**
    取得当前的XMPPStream
    
    :returns: 
    */
    func xmppStream() -> XMPPStream {
        return self.appDelegate().xmppStream
    }
    

}
