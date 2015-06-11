//
//  User.swift
//  BTrip
//
//  Created by Vetech on 15/6/8.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit
/*
{
"abbreviation" : "鲍方亮",
"areOpen" : "1",
"availablePoints" : "21",
"checkPwdCode" : "2",
"checkPwdResult" : "0",
"dateOfBirth" : "1987-10-10",
"documentType" : "NI",
"earnPoints" : "21",
"gender" : "M",
"hydj" : "1007201",
"identificationNumbers" : "420115198710102816",
"memberId" : "140404164528820342",
"memberLevels" : "普通会员",
"memberNumber" : "15972092413",
"memberSource" : "1",
"memberType" : "P",
"name" : "鲍方亮",
"password" : "a123456",
"phone" : "15972092413",
"qkje" : "0",
"registrationName" : "15972092413",
"resultCode" : "1",
"status" : "1",
"totalSpendPoints" : "0",
"yckje" : "0"
}
*/
class User: NSObject, NSCoding {
   
    var name: String?
    var password: String?
    var phone: String?
    var idtype: String?
    var idnumber: String?
    var regname: String?
    var memberid: String?
    var gender: String?
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
    
    }
}
