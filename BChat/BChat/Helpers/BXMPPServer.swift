//
//  BXMPPServer.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

@objc protocol BXMPPServerDelegate {
    optional func setupStream()
    optional func getOnline()
    optional func getOffline()
}

class BXMPPServer: NSObject, BXMPPServerDelegate {
   
    var password: String?
    var isOpen: Bool?
    
    var xmppStream: XMPPStream!
    
    static var server: BXMPPServer?
    
    class func sharedServer() -> BXMPPServer {
        if server == nil {
            server = self.init()
        }
        return server!
    }
    
    func setupStream() {
        self.xmppStream = XMPPStream()
        // 在主线程中运行
        self.xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    // 取得在线人员
    func getOnline() {
        var presence = XMPPPresence()
        self.xmppStream.sendElement(presence)
    }
    
    func getOffline() {
        var presence = XMPPPresence(type: "unavailable")
        self.xmppStream.sendElement(presence)
    }
    
    func connect() -> Bool {
        NSLog("111111")
        
        self.setupStream()
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var userId = defaults.stringForKey("userId")
        var pass = defaults.stringForKey("pass")
        
        if !self.xmppStream.isDisconnected() {
            return true
        }
        
        if userId == nil || password == nil {
            return false
        }
        
        self.xmppStream.myJID = XMPPJID.jidWithString(userId)
        self.xmppStream.hostName = defaults.stringForKey("server")
        password = pass
        
        var error: NSError?
        if !self.xmppStream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error) {
            var errorStr = "不能连接服务器 \(error)"
            var alert = UIAlertView(title: "Error", message: errorStr, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            
            return false
        }
        return true
    }
    
    func disconnect() {
        self.getOffline()
        self.xmppStream.disconnect()
    }
    
}
