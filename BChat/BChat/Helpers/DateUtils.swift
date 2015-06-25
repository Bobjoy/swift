//
//  Statics.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

//TODO: 使用单例模式，保持App日期格式一致
class DateUtils {
    
    class func getCurrentTime() -> String {
        var nowUTC = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        return dateFormatter.stringFromDate(nowUTC)
    }
    
    class func formatDate(dateStr: String, var pattern: String?) -> String {
        if ( pattern == nil) {
            pattern = "yyyy年MM月dd日 HH:mm:ss"
        }
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = pattern!
        // 转换后的日期
        var convertedDate = dateFormatter.dateFromString(dateStr)!
        return dateFormatter.stringFromDate(convertedDate)
    }
    
    class func formatUTCDate(dateStr: String, var pattern: String?) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // 2015-06-23T05:26:19.699Z
        // 转换后的日期
        var convertedDate = dateFormatter.dateFromString(dateStr)!
        
        if ( pattern == nil) {
            pattern = "yyyy年MM月dd日 HH:mm:ss"
        }
        dateFormatter.dateFormat = pattern!
        return dateFormatter.stringFromDate(convertedDate)
    }
    
    class func formateDate(date: NSDate, var pattern: String?) -> String {
        if ( pattern == nil) {
            pattern = "yyyy年MM月dd日 HH:mm:ss"
        }
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = pattern!
        return dateFormatter.stringFromDate(date)
    }
}
