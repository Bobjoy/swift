//
//  BMessageDelegate.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

protocol BMessageDelegate{
    
    func newMessageReceived(message: BJabberMessage)
   
}
