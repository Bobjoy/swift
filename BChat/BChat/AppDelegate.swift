//
//  AppDelegate.swift
//  BChat
//
//  Created by Vetech on 15/6/17.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate {

    var window: UIWindow?
    
    private let kServer = "172.16.1.251"
    
    private var mPassword: String?
    private var mIsOpen: Bool?
    
    internal var xmppStream: XMPPStream!
    internal var messageDelegate: BMessageDelegate?
    internal var chatDelegate: BChatDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.disconnect()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.connect()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        BXMPPHelper.sharedInstance().destoryResource()
    }
    
    // 初始化XMPPStream
    func setupStream() {
        xmppStream = XMPPStream()
        xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    // 发送在线状态
    func goOnline() {
        var presence = XMPPPresence()
        xmppStream.sendElement(presence)
    }
    
    // 发送下线状态
    func goOffline() {
        var presence = XMPPPresence(type: "unavailable")
        xmppStream.sendElement(presence)
    }
    
    func connect() -> Bool {
        self.setupStream()
        
        // 从本地获取
        var defaults = NSUserDefaults.standardUserDefaults()
        var userId = defaults.stringForKey("userId")
        var pass = defaults.stringForKey("pass")
        var server = defaults.stringForKey("server")
        
        if !xmppStream.isDisconnected() {
            return true
        }
        
        if userId == nil || pass == nil {
            return false
        }
        
        // 设置用户
        xmppStream.myJID = XMPPJID.jidWithString(userId)
        // 设置服务器
        xmppStream.hostName = server!
        // 密码
        mPassword = pass
        
        // 连接服务器
        var error: NSError?
        if !xmppStream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error) {
            println("cant connect \(server!)")
            return false
        }
        
        return true
    }
    
    func disconnect() {
        self.goOffline()
        xmppStream.disconnect()
    }
    
    // 连接服务器
    func xmppStreamDidConnect(sender: XMPPStream!) {
        mIsOpen = true
        var error: NSError?
        // 验证密码
        xmppStream.authenticateWithPassword(mPassword, error: &error)
    }
    
    // 验证通过
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        self.goOnline()
    }
    
    /**
    *  收到消息
    */
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        // 发送人
        var from = message.attributeStringValueForName("from")
        // 正在输入
        var composingEle = message.elementForName("composing")
        // 停止输入
        var pausedEle = message.elementForName("paused")
        // 消息内容
        var bodyEle = message.elementForName("body")
        
        if bodyEle != nil{
            var msg = bodyEle.stringValue()
            
            var dict = NSMutableDictionary()
            dict.setObject(msg, forKey: "msg")
            dict.setObject(from, forKey: "sender")
            // 消息接收到的时间
            dict.setObject(DateUtils.getCurrentTime(), forKey: "time")
            // 消息委托
            messageDelegate?.newMessageReceived(dict)
        }
    }
    
    /**
    *  收到好友状态
    */
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        // 取得好友状态: online/offline
        var presenceType: NSString = presence.type()
        // 当前用户
        var userId = sender.myJID.user
        // 在线用户
        var presenceFromUser: NSString = presence.from().user
        
        if !presenceFromUser.isEqualToString(userId) {
            // 在线状态
            if presenceType.isEqualToString("available") {
                // 用户列表委托
                chatDelegate?.newBuddyOnline("\(presenceFromUser)@\(kServer)")
            } else if (presenceType.isEqualToString("unavailable")) {
                chatDelegate?.buddyWentOffline("\(presenceFromUser)@\(kServer)")
            }
        }
    }
    
}

