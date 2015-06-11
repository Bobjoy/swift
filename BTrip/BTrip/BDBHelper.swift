//
//  BDBHelper.swift
//  BTrip
//
//  Created by Vetech on 15/6/8.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class BDBHelper: NSObject {
    
    private var db: COpaquePointer = nil
    
    required init(dbPath: String) {
        println("db path:" + dbPath)
        // String类的路径，转换成cString
        let cpath = dbPath.cStringUsingEncoding(NSUTF8StringEncoding)
        // 打开数据库
        let error = sqlite3_open(cpath!, &db)
        // 
        if error != SQLITE_OK {
            sqlite3_close(db)
        }
    }
    
    func createTable() -> Bool {
        var sql = "create able user(id integer primary key autoincrement not null, username text not null, password text not null, email text, age integer)"
        
        var execResult = sqlite3_exec(db, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, nil, nil, nil)
        
        if execResult != SQLITE_OK {
            return false
        }
        
        return true
    }
}
