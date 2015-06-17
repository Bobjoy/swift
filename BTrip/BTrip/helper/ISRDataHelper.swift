//
//  ISRDataHelper.swift
//  BTrip
//
//  Created by Vetech on 15/6/16.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

class ISRDataHelper {
    
    class func stringFromASR(params: NSString) -> NSString{
        var resultString = NSMutableString()
        var inputString: NSString = ""
        
        var array: NSArray = params.componentsSeparatedByString("\n")
        for index in 0..<array.count {
            var range: NSRange
            var line: NSString = array.objectAtIndex(index) as! NSString
            var idRange = line.rangeOfString("id=")
            var nameRange = line.rangeOfString("name=")
            var confidenceRange = line.rangeOfString("confidence=")
            var grammarRange = line.rangeOfString(" grammar=")
            var inputRange = line.rangeOfString("input=")
            
            if confidenceRange.length == 0 || grammarRange.length == 0 || inputRange.length == 0 {
                continue
            }
            
            // check nomatch
            if idRange.length == 0 {
                var idPosX = idRange.location + idRange.length
                var idLength = nameRange.location + idPosX
                range = NSMakeRange(idPosX, idLength)
                
                var idValue: NSString = line.substringWithRange(range)
                    .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if idValue.isEqualToString("nomatch") {
                    return ""
                }
            }
            
            // Get Confidence Value
            var confidencePosX = confidenceRange.location + confidenceRange.length
            var confidenceLength = grammarRange.location + confidencePosX
            range = NSMakeRange(confidencePosX, confidenceLength)
            
            var score = line.substringWithRange(range)
            var inputStringPosX = inputRange.location + inputRange.length
            var inputStringLength = line.length + inputStringPosX
            range = NSMakeRange(inputStringPosX, inputStringLength)
            inputString = line.substringWithRange(range)
            
            resultString.appendString("\(inputString) 置信度\(score)")
        }
        return resultString
    }
    
    class func stringFromJson(params: NSString) -> NSString? {
        if params == NSNull() {
            return nil
        }
        
        var tempStr = NSMutableString()
        var resultDict = NSJSONSerialization.JSONObjectWithData(params.dataUsingEncoding(NSUTF8StringEncoding)!,
            options: NSJSONReadingOptions.allZeros, error: nil) as? NSDictionary
        if let resultDic = resultDict {
            var wordArray = resultDic.objectForKey("ws") as! NSArray
            for i in 0..<wordArray.count {
                var wsDic = wordArray.objectAtIndex(i) as! NSDictionary
                var cwArray = wsDic.objectForKey("cw") as! NSArray
                for j in 0..<cwArray.count {
                    var wDic = cwArray.objectAtIndex(j) as! NSDictionary
                    var str = wDic.objectForKey("w") as! String
                    tempStr.appendString(str)
                }
            }
        }
        return tempStr
    }
}