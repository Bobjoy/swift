//
//  ExtensionUtils.swift
//  Vetrip
//
//  Created by Vetech on 15/5/28.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import UIKit

extension UIColor {
    class func colorWithHexString(hexString: NSString, alphaValue: CGFloat) -> UIColor {
        
        //删除字符串中的空格
        var cString: NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        // String should be 6 or 8 characters
        if (cString.length < 6 ) {
            return UIColor.clearColor()
        }
        // strip 0X if it appears
        //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
        if (cString.hasPrefix("0X")) {
            cString = cString.substringFromIndex(2)
        }
        //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(1)
        }
        if (cString.length != 6) {
            return UIColor.clearColor()
        }
        
        // Separate into r, g, b substrings
        var range: NSRange = NSRange(location: 0, length: 2)
        //r
        range.location = 0
        var rString = cString.substringWithRange(range);
        //g
        range.location = 2;
        var gString = cString.substringWithRange(range);
        //b
        range.location = 4;
        var bString = cString.substringWithRange(range);
        
        // Scan values
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(
            red: CGFloat(r)/255.0,
            green: CGFloat(g)/255.0,
            blue: CGFloat(b)/255.0,
            alpha: alphaValue
        )
    }
    
    class func colorWithHexString(hexString: NSString) -> UIColor {
        return colorWithHexString(hexString, alphaValue: 1.0)
    }
}