//
//  BXMPPHelper.swift
//  BChat
//
//  Created by Vetech on 15/6/17.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class BXMPPHelper: NSObject, XMPPStreamDelegate, XMPPRosterDelegate {
    
    typealias BCompletionBlock = (Bool, String?) -> ()
    
    private static var instance: BXMPPHelper? = nil
    
    let kServer = "172.16.1.251"
    let kUserJIDKey = "userid"
    let kUserPasswordKey = "pass"
    
    var mIsLogining = false
    var mIsRegistering = false
    var mJid: String?
    var mPassword: String?
    var mCompletionBlock: BCompletionBlock?
    
    var mXmppStream: XMPPStream!
    var mXmppReconnect: XMPPReconnect!
    
    var mXmppRoster: XMPPRoster!
    var mXmppRosterStorage: XMPPRosterCoreDataStorage!
    
    var mXmppvCardStorage: XMPPvCardCoreDataStorage!
    var mXmppvCardTempModule: XMPPvCardTempModule!
    var mXmppvCardAvatarModule: XMPPvCardAvatarModule!
    
    var mXmppCapailitiesStorage: XMPPCapabilitiesCoreDataStorage!
    var mXmppCapabilities: XMPPCapabilities!
    
    var mXmppMessageStorage: XMPPMessageArchivingCoreDataStorage!
    var mXmppMessageArchiving: XMPPMessageArchiving!
    
    override init() {
        super.init()
    }
    
    class func sharedInstance() -> BXMPPHelper {
        if instance == nil {
            instance = BXMPPHelper()
            instance!.setupXmppStream()
        }
        return instance!
    }
    
    /**
    在初始化时，配置一下
    */
    func setupXmppStream() {
        assert(mXmppStream == nil, "-setupXmppStream method called multiple times")
        mJid = NSUserDefaults.standardUserDefaults().objectForKey(kUserJIDKey) as? String
        mPassword = NSUserDefaults.standardUserDefaults().objectForKey(kUserPasswordKey) as? String
        
        println("setupXmppStream: jid=\(mJid!), pass=\(mPassword!)")
        
        mXmppStream = XMPPStream()
        
        //#if !TARGET_IPHONE_SIMULATOR
            // 设置此行为YES,表示允许socket在后台运行
            // 在模拟器上是不支持在后台运行的
            mXmppStream.enableBackgroundingOnSocket = true
        //#endif
        
        // XMPPReconnect模块会监控意外断开连接并自动重连
        mXmppReconnect = XMPPReconnect()
        
        // 配置花名册并配置本地花名册储存
        mXmppRosterStorage = XMPPRosterCoreDataStorage()
        mXmppRoster = XMPPRoster(rosterStorage: mXmppRosterStorage)
        mXmppRoster.autoAcceptKnownPresenceSubscriptionRequests = true
        mXmppRoster.autoFetchRoster = true
        
        // 配置vCard存储支持，vCard模块结合vCardTempModule可下载用户Avatar
        mXmppvCardStorage = XMPPvCardCoreDataStorage()
        mXmppvCardTempModule = XMPPvCardTempModule(withvCardStorage: mXmppvCardStorage)
        mXmppvCardAvatarModule = XMPPvCardAvatarModule(withvCardTempModule: mXmppvCardTempModule)
        
        // XMPP特性模块配置，用于处理复杂的哈希协议等
        mXmppCapailitiesStorage = XMPPCapabilitiesCoreDataStorage()
        mXmppCapabilities = XMPPCapabilities(capabilitiesStorage: mXmppCapailitiesStorage)
        mXmppCapabilities.autoFetchHashedCapabilities = true
        mXmppCapabilities.autoFetchNonHashedCapabilities = false
        
        // 激活XMPP stream
        mXmppReconnect.activate(mXmppStream)
        mXmppRoster.activate(mXmppStream)
        mXmppvCardTempModule.activate(mXmppStream)
        mXmppvCardAvatarModule.activate(mXmppStream)
        mXmppCapabilities.activate(mXmppStream)
        
        // 消息相关
        mXmppMessageStorage = XMPPMessageArchivingCoreDataStorage()
        mXmppMessageArchiving = XMPPMessageArchiving(messageArchivingStorage: mXmppMessageStorage)
        mXmppMessageArchiving.clientSideMessageArchivingOnly = true
        mXmppMessageArchiving.activate(mXmppStream)
        
        // 添加代理
        mXmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        mXmppRoster.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        mXmppMessageArchiving.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
    }
    
    /**
    释放资源
    */
    func destoryResource() {
        mXmppStream.removeDelegate(self)
        mXmppRoster.removeDelegate(self)
        mXmppReconnect.deactivate()
        mXmppRoster.deactivate()
        mXmppvCardTempModule.deactivate()
        mXmppvCardAvatarModule.deactivate()
        mXmppCapabilities.deactivate()
        mXmppMessageArchiving.deactivate()
        
        mXmppStream.disconnect()
        
        mXmppStream = nil
        mXmppRoster = nil
        mXmppReconnect = nil
        mXmppRosterStorage = nil
        mXmppvCardTempModule = nil
        mXmppvCardAvatarModule = nil
        mXmppvCardStorage = nil
        mXmppCapabilities = nil
        mXmppCapailitiesStorage = nil
        mXmppMessageStorage = nil
        mXmppMessageArchiving = nil
    }
    
    func registerWithJid(jidString: String?, password: String?, completion: BCompletionBlock?) {
        mIsLogining = false
        
        if mIsRegistering {
            return
        }
        
        if jidString == nil || password == nil {
            if completion != nil {
                completion!(false, "用户名或者密码不能为空")
            }
            return
        }
        
        mJid = jidString!
        mPassword = password!
        mCompletionBlock = completion
        
        mIsRegistering = true
        if mXmppStream.isConnected() {
            if self.connect() {
                mIsRegistering = false
                
                if completion != nil {
                    completion!(false, "连接服务器失败")
                }
            }
            return
        }
        
    }
    
    func registerWithJid(var jidString: String) {
        if !jidString.hasSuffix(kServer) {
            jidString = "\(jidString)@\(kServer)"
        }
        
        mXmppStream.myJID = XMPPJID.jidWithString(jidString)
        
        // 设置服务器
        mXmppStream.hostName = kServer
        
        var error: NSError?
        mIsRegistering = true
        if mXmppStream.registerWithPassword(mPassword, error: &error) {
            NSLog("注册账号失败：\(error?.description)")
            mIsRegistering = false
            
            if mCompletionBlock != nil {
                mCompletionBlock!(false, error?.description)
            }
        }
    }
    
    func connect() -> Bool {
        if mXmppStream.isDisconnected() {
            return false
        }
        
        if mJid == nil || mPassword == nil {
            return false
        }
        
        mXmppStream.myJID = XMPPJID.jidWithString(mJid)
        mXmppStream.hostName = kServer
        
        // 连接
        var error: NSError?
        if mXmppStream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error) {
            var alertView = UIAlertView(title: "Error connecting", message: "See console for error details", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
            NSLog("Error connecting: \(error?.description)")
            
            return false
        }
        return true
    }
    
    func xmppStreamDidRegister(sender: XMPPStream!) {
        NSLog("注册成功")
        
        if mCompletionBlock != nil && mIsRegistering {
            mCompletionBlock!(true, nil)
        }
        
        mIsRegistering = false
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        if mIsRegistering {
            self.registerWithJid(mJid!)
            return
        }
        
        // 登录成功
        if mCompletionBlock != nil && mIsLogining {
            mCompletionBlock!(true, nil)
        }
        
        NSLog("密码校验成功，用户将要上线")
        mIsLogining = false
        
    }
    
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        if mIsRegistering {
            self.registerWithJid(mJid!)
            return
        }
        
        if mIsLogining {
            self.loginWithJid(mJid!)
            return
        }
        
        mIsLogining = false
        NSLog("didNotAuthenticate: 密码校验失败，登录不成功，原因是：\(error.XMLString())")
    }
    
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        NSLog("注册失败：\(error)")
        
        var query: DDXMLElement = error.elementForName("query")
        var username: DDXMLElement = query.elementForName("username")
        var password: DDXMLElement = query.elementForName("password")
        
        var errorNode: DDXMLElement = error.elementForName("error")
        var code = errorNode.attributeIntValueForName("code")
        NSLog("\(username.stringValue()) \(password.stringValue())")
        if mCompletionBlock != nil && mIsRegistering && mIsLogining {
            mCompletionBlock!(false, "\(code)")
        }
        
        mIsRegistering = false
    }
    
    func loginWithJid(jidString: String?, password: String?, completion: BCompletionBlock?) {
        mIsRegistering = false
        
        if mXmppStream.isAuthenticated() {
            if completion != nil {
                completion!(true, nil)
            }
            return
        }
        
        if mIsLogining {
            return
        }
        
        if jidString == nil || password == nil {
            if completion != nil {
                completion!(false, "用户名或者密码错误")
            }
            return
        }
        
        mJid = jidString
        mPassword = password
        mCompletionBlock = completion
        mIsLogining = true
        
        if !mXmppStream.isConnected() {
            if self.connect() {
                mIsLogining = false
                
                if completion != nil {
                    completion!(false, "连接服务器失败")
                }
            }
            return
        }
        
        self.loginWithJid(jidString!)
    }
    
    func loginWithJid(var jidString: String) {
        if jidString.hasSuffix(kServer) {
            jidString = "\(jidString)@\(kServer)"
        }
        mXmppStream.myJID = XMPPJID.jidWithString(jidString)
        
        // 设置服务器
        mXmppStream.hostName = kServer
        
        var error: NSError?
        mIsLogining = true
        if mXmppStream.authenticateWithPassword(mPassword, error: &error) {
            NSLog("登录失败：\(error?.description)")
            mIsLogining = false
            if mCompletionBlock != nil {
                mCompletionBlock!(false, error?.description)
            }
        }
    }
    
    func goOnline() {
        var presence = XMPPPresence()
        var domain: NSString = mXmppStream.myJID.domain
        
        if domain.isEqualToString("gmail.com") || domain.isEqualToString("gtalk.com") || domain.isEqualToString("talk.google.com") {
            var priority = DDXMLElement(name: "priority", stringValue: "24")
            presence.addChild(priority)
        }
        
        mXmppStream.sendElement(presence)
    }
    
}
