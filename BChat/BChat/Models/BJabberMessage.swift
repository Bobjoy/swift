//
//  BuddyMessage.swift
//  BChat
//
//  Created by Vetech on 15/6/23.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

struct BJabberMessage {
    var id = ""
    var fromUser = ""
    var fromUserId = ""
    var toUser = ""
    var toUserId = ""
    var type = ""
    var time = ""
    var body = ""
    var bodyWithHtml = ""
    
    var isComposing = false
    var isDelay = false
    
    init(){
    
    }
    
    init(message: XMPPMessage) {
        self.id = message.attributeStringValueForName("id")
        // 消息发送者
        self.fromUser = message.from().user
        self.fromUserId = self.fromUser + "@" + message.from().domain
        // 消息接收者
        self.toUser = message.to().user
        self.toUserId = message.attributeStringValueForName("to")
        // 消息类型
        self.type = message.attributeStringValueForName("type")
        // 正在输入
        if ( message.elementForName("composing") != nil ) {
            self.isComposing = true
        }
        // 停止输入
        if ( message.elementForName("paused") != nil ) {
            self.isComposing = false
        }
        // 离线消息
        var delayEle = message.elementForName("delay")
        if ( delayEle != nil ) {
            self.isDelay = true
            var utcTime = delayEle.attributeStringValueForName("stamp")
            self.time = DateUtils.formatUTCDate(utcTime, pattern: nil)
        }
        // 消息内容
        var bodyEle = message.elementForName("body")
        if ( bodyEle != nil ) {
            self.body = bodyEle.stringValue()
            if let htmlEle = message.elementForName("html") {
                self.bodyWithHtml = htmlEle.XMLString()
            }
        }
        
    }
    
    //TODO: 将对象转化为XML
    func toXML() {
        
    }
    
}