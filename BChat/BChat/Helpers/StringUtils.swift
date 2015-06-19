//
//  NSString+stringFrame.swift
//  BChat
//
//  Created by Vetech on 15/6/19.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

class StringUtils {
    
    class func stringSize(string: NSString, size: CGSize, fontSize: CGFloat) -> CGSize {
        var attributes = [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)]
        var rect = string.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size
    }
}