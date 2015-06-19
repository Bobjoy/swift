//
//  BChatDelegate.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

protocol BChatDelegate {
    
    func newBuddyOnline(buddyName: String)
    
    func buddyWentOffline(buddyName: String)
    
    func didDisconnect()
}