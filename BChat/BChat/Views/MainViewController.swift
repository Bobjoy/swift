//
//  MainViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, BStateDelegate, BMessageDelegate {

    @IBOutlet var tbView: UITableView!
    @IBOutlet weak var online: UISwitch!
    
    private var mChatUserName: String!
    private var mXmppStream: XMPPStream?
    
    private var mUnreadMessages: [BJabberMessage]!
    private var mUserStates: [BUserState]!
    
    var isLogined = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化数组
        mUnreadMessages = [BJabberMessage]()
        mUserStates = [BUserState]()
        
        // UITableView的数据源和代理
        tbView.delegate = self
        tbView.dataSource = self
        
        // 状态代理
        appDelegate().stateDelegate = self
        
        // 判断登录
        var myID = NSUserDefaults.standardUserDefaults().objectForKey(Constant.udUserId) as? String
        if ( myID != nil ) {
            self.logon()
        } else {
            self.login()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate().messageDelegate = self
    }
    
    @IBAction func switchState(sender: AnyObject) {
        if ( isLogined ) {
            // 下线
            logoff()
        } else {
            // 上线
            logon()
        }
    }
    
    @IBAction func login() {
        self.performSegueWithIdentifier("login", sender: self)
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mUserStates.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellid = "userItem"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellid, forIndexPath: indexPath) as! UITableViewCell
        if cell == NSNull() {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellid)
        }
        
        let state = mUserStates[indexPath.row]
        var unreadNum = 0
        for msg in mUnreadMessages {
            if (state.userId == msg.fromUserId) {
                unreadNum++
            }
        }
        
        cell.textLabel?.text = state.userId + "(\(unreadNum))"
        cell.detailTextLabel?.text = state.isOn ? "在线" : "离线"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mChatUserName = mUserStates[indexPath.row].userId
        self.performSegueWithIdentifier("chat", sender: self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "chat" ) {
            var chatView = segue.destinationViewController as! ChatViewController
            chatView.chatWithUser = mChatUserName
            for msg in mUnreadMessages {
                if ( msg.fromUserId == mChatUserName ) {
                    chatView.messages.append(msg)
                }
            }
            // 移除
            mUnreadMessages = mUnreadMessages.filter{ $0.fromUserId != self.mChatUserName}
            self.tbView.reloadData()
        }
    }
    
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        //如果是登陆界面的完成按钮点击了, 开始登陆
        let srcView = segue.sourceViewController as? LoginViewController
        if let loginView = srcView {
            if ( loginView.requireLogin ) {
                //注销前一个用户
                self.logoff()
                //登陆现用户
                self.logon()
            }
        }
    }
    
    //MARK: - BStateDelegate
    
    func isOn(state: BUserState) {
        for (index, oldState) in enumerate(mUserStates) {
            if ( state.userId == oldState.userId ) {
                // 移除旧的状态
                mUserStates.removeAtIndex(index)
                break
            }
        }
        // 添加新的状态
        mUserStates.append(state)
        // 刷新表格
        self.tbView.reloadData()
    }
    
    func isOff(state: BUserState) {
        for (index, oldState) in enumerate(mUserStates) {
            if ( state.userId == oldState.userId ) {
                mUserStates[index].isOn = false
            }
        }
        // 刷新表格
        self.tbView.reloadData()
    } // BStateDelegate End
    
    //MARK: - BMessageDelegate
    
    func newMessageReceived(message: BJabberMessage) {
        if ( !message.body.isEmpty ) {
            println("消息：" + message.body)
            mUnreadMessages.append(message)
            self.tbView.reloadData()
        }
    } // BMessageDelegate End
    
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
    
    func logon() {
        // 清空未读和状态数组
        mUnreadMessages.removeAll(keepCapacity: false)
        mUserStates.removeAll(keepCapacity: false)
        self.appDelegate().connect()
        self.online.on = true
        isLogined = true
        
        // 取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey(Constant.udUserId)
        self.navigationItem.title = "\(myID!)的好友"
        // 刷新表格
        self.tbView.reloadData()
    }
    
    func logoff() {
        // 清空未读和状态数组
        mUnreadMessages.removeAll(keepCapacity: false)
        mUserStates.removeAll(keepCapacity: false)
        
        appDelegate().disconnect()
        
        isLogined = false
        // 刷新表格
        self.tbView.reloadData()
    }
    
}
