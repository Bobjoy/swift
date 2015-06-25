//
//  BStateDelegate.swift
//  BChat
//
//  Created by Vetech on 15/6/23.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

protocol BStateDelegate {
    
    func isOn(state: BUserState)
    func isOff(state: BUserState)
}