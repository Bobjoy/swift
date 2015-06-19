//
//  ChatViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController, BMessageDelegate {
    
    @IBOutlet var tbView: UITableView!
    private let padding: CGFloat = 20.0
    private var textSize: CGSize!
    
    var chatWithUser: String?
    
    @IBOutlet var messageTextField: UITextField!
    var messages: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = NSMutableArray()
        textSize = CGSizeMake(self.view.frame.width-60, 10000)
        // 设置消息接收代理
        var delegate = self.appDelegate()
        delegate.messageDelegate = self
        
        // 设置标题栏
        var closeBar = UIBarButtonItem(title: "关闭  ", style: .Done, target: self, action: "close")
        self.initNavBar(chatWithUser, left: nil, right: closeBar)

    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cellid")
        var dict = messages.objectAtIndex(indexPath.row) as! NSDictionary
        // 发送者
        var sender = dict.objectForKey("sender") as! NSString
        if sender.containsString("/") {
            sender = sender.stringByDeletingLastPathComponent
        }
        // 消息
        var message = dict.objectForKey("msg") as! NSString
        // 时间
        var time = dict.objectForKey("time") as! String
        
        var size = StringUtils.stringSize(message, size: textSize, fontSize: 13)
        println(size)
        size.width += (padding)/2
        
        cell.messageContentView.text = message as! String
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.userInteractionEnabled = false
        
        var bgImage: UIImage?
        // 发送消息
        if sender.isEqualToString("you") {
            // 背景图片
            bgImage = UIImage(named: "BlueBubble2.png")?.stretchableImageWithLeftCapWidth(20, topCapHeight: 15)
            cell.messageContentView.frame = CGRectMake(padding, padding*2, size.width, size.height)
            cell.bgImageView.frame = CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2, size.width + padding, size.height + padding)
        } else {
            bgImage = UIImage(named: "GreenBubble2.png")?.stretchableImageWithLeftCapWidth(14, topCapHeight: 15)
            cell.messageContentView.frame = CGRectMake(320-size.width - padding, padding*2, size.width, size.height)
            cell.bgImageView.frame = CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2, size.width + padding, size.height + padding)
        }
        
        cell.bgImageView.image = bgImage
        cell.senderAndTimeLabel.text = "\(sender) \(time)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var dict = messages.objectAtIndex(indexPath.row) as! NSMutableDictionary
        var msg = dict.objectForKey("msg") as! NSString
        var size = StringUtils.stringSize(msg, size: textSize, fontSize: 13)
        size.height += padding*2
        println(size)
        var height = size.height < 65 ? 65 : size.height
        return height
    }

    // MARK: - BMessageDelegate
    
    func newMessageReceived(messageContent: NSDictionary) {
        messages.addObject(messageContent)
        self.tbView.reloadData()
    }
    
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        var message = self.messageTextField.text
        
        if count(message) > 0 {
            // XMPPFramework主要是通过KissXML来生成XML文件
            // 生成<body>文档
            var body = DDXMLElement.elementWithName("body") as! DDXMLElement
            body.setStringValue(message)
            
            // 生成XML消息文档
            var msg = DDXMLElement.elementWithName("message") as! DDXMLElement
            // 消息类型
            msg.addAttributeWithName("type", stringValue: "chat")
            // 发送给谁
            msg.addAttributeWithName("to", stringValue: chatWithUser)
            // 由谁发送
            msg.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey("userId"))
            // 组合
            msg.addChild(body)
            
            // 发送消息
            self.xmppStream().sendElement(msg)
            
            self.messageTextField.text = ""
            self.messageTextField.resignFirstResponder()
            
            var dictionary = NSMutableDictionary()
            dictionary.setObject(message, forKey: "msg")
            dictionary.setObject("you", forKey: "sender")
            // 加入发送时间
            dictionary.setObject(DateUtils.getCurrentTime(), forKey: "time")
            
            messages.addObject(dictionary)
            
            // 重新刷新tableView
            self.tbView.reloadData()
        }
    }
    
    func xmppStream() -> XMPPStream {
        return self.appDelegate().xmppStream
    }

}
