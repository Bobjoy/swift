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
    
    var xmppStream: XMPPStream!
    // 消息代理
    var messageDelegate: BMessageDelegate?
    // 聊天代理
    var chatDelegate: BChatDelegate?
    // 状态代理
    var stateDelegate: BStateDelegate?

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
        var presence = XMPPPresence(type: Constant.msgUnavailable)
        xmppStream.sendElement(presence)
    }
    
    func connect() -> Bool {
        self.setupStream()
        
        // 从本地获取
        var defaults = NSUserDefaults.standardUserDefaults()
        var userId = defaults.stringForKey(Constant.udUserId)
        var pass = defaults.stringForKey(Constant.udPass)
        var server = defaults.stringForKey(Constant.udServer)
        
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
    
    /**
    *  断开连接
    */
    func disconnect() {
        if ( xmppStream.isConnected() ) {
            self.goOffline()
            xmppStream.disconnect()
        }
    }
    
    /**
    *  收到好友消息
    */
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        // 聊天消息
        if ( message.isChatMessage() ) {
            var msg = BJabberMessage(message: message)
            // 消息委托
            messageDelegate?.newMessageReceived(msg)
        }
    }
    
    /**
    *  收到好友状态
    */
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        // 当前用户ID
        let me = sender.myJID.user
        // 好友ID
        let user = presence.from().user
        // 用户所在的域
        let domain = presence.from().domain
        // 状态类型
        let pType = presence.type()
        // 如果状态不是自己的
        if ( user != me ) {
            var state = BUserState()
            state.userId = "\(user)@\(domain)"
            // 上线
            if ( pType == Constant.msgAvailable ) {
                state.isOn = true
                stateDelegate?.isOn(state)
            }
            // 下线
            else if ( pType == Constant.msgUnavailable ) {
                state.isOn = false
                stateDelegate?.isOff(state)
            }
        }
    }
    
    /**
    *  连接服务器
    */
    func xmppStreamDidConnect(sender: XMPPStream!) {
        mIsOpen = true
        var error: NSError?
        // 验证密码
        xmppStream.authenticateWithPassword(mPassword, error: &error)
    }
    
    /**
    *  验证通过
    */
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        self.goOnline()
    }
    
}

