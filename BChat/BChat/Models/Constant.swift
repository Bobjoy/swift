//
//  MessageState.swift
//  BChat
//
//  Created by Vetech on 15/6/23.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

enum MessageState {
    case COMPOSING, PAUSED
}

struct Constant {
    // NSUserDefaults中存储数据的key
    static var udUserId = "userId"
    static var udPass = "udPass"
    static var udServer = "server"
    // 消息节点的元素名称
    static var enComposing = "composing"
    static var enPaused = "paused"
    static var enBody = "body"
    static var enMsg = "message"
    // 
    static var keyMsg = "msg"
    static var keySender = "sender"
    static var keyTime = "time"
    // 上下线状态
    static var msgAvailable = "available"
    static var msgUnavailable = "unavailable"
    
}

struct BUserState {
    var userId = ""
    var isOn = false
}