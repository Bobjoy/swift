//
//  BXMLModelHelper.swift
//  BTrip
//
//  Created by Vetech on 15/6/8.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class BXMLHelper {
    
    class func toXML(root: NSString, dictionary: [String:String]) -> String {
        var arr = Array(count: dictionary.count, repeatedValue: "")
        arr.append("<\(root)>")
        for (key, value) in dictionary {
            arr.append("<\(key)>\(value)</\(key)>")
        }
        arr.append("</\(root)>")
        return "".join(arr)
    }
    
}
