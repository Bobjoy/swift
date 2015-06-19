//
//  ViewController.m
//  SQLiteTest
//
//  Created by Vetech on 15/6/19.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"

#define kDatabaseName @"SQLiteTest.sqlite"

@interface ViewController ()

@end

@implementation ViewController
@synthesize databaseFilePath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.databaseFilePath = [NSHomeDirectory() stringByAppendingPathComponent:kDatabaseName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender {
    NSLog(@"backgroundTap");
    for (int i=1; i<=4; i++) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        [textField resignFirstResponder];
    }
}

- (IBAction)loadData:(id)sender {
    // 打开或者创建数据库
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"打开数据库失败!");
    }
    // 创建数据库表
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FIELDS (TAG INTEGER PRIMARY KEY, FIELD_DATA TEXT);";
    char * errorMsg;
    if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(0, @"创建数据表错误：%s", errorMsg);
    }
    // 执行查询
    NSString *query = @"SELECT TAG, FIELD_DATA FROM FIELDS ORDER BY TAG";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        // 依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(stmt) == SQLITE_OK) {
            // 获取数据
            int tag = sqlite3_column_int(stmt, 0);
            char *rowData = (char *)sqlite3_column_text(stmt, 1);
            // 根据tag获取TextField
            UITextField *textField = (UITextField *)[self.view viewWithTag:tag];
            // 设置文本
            textField.text = [[NSString alloc]initWithUTF8String:rowData];
        }
        sqlite3_finalize(stmt);
    }
    // 关闭数据库
    sqlite3_close(database);
}

- (IBAction)addField:(id)sender {
    // 打开数据库
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"打开数据库失败!");
        return;
    }
    
    // 想表格插入四行数据
    for (int i=1; i<=4; i++) {
        // 根据tag获取TextField
        UITextField *textField = (UITextField *)[self.view viewWithTag:i];
        // 使用约束变量插入数据
        char *update = "INSERT OR REPLACE INTO FIELDS (TAG, FIELD_DATA) VALUES (?, ?);";
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1, i);
            sqlite3_bind_text(stmt, 2, [textField.text UTF8String], -1, NULL);
        }
        char *errorMsg = NULL;
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSLog(@"更新数据库表FIELDS出错：%s", errorMsg);
        } else {
            NSLog(@"添加成功");
        }
        sqlite3_finalize(stmt);
    }
    // 关闭数据库
    sqlite3_close(database);
}

@end
