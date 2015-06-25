//
//  ChatViewController.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, BMessageDelegate {
    
    @IBOutlet var tbView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    
    private let padding: CGFloat = 20.0
    private var textSize: CGSize!
    // 消息列表
    var messages: [BJabberMessage] = [BJabberMessage]()
    // 当前聊天的好友
    var chatWithUser: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 当前聊天的好友
        self.navigationItem.title = chatWithUser
        
        textSize = CGSizeMake(self.view.frame.size.width-120, 20000)
        // 设置消息接收代理
        var delegate = self.appDelegate()
        delegate.messageDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "msgCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
        } else {
            for cellView in cell!.subviews {
                cellView.removeFromSuperview();
            }
        }
        
        var message = messages[indexPath.row]
        // 创建头像
        var fromSelf = false
        var photoX: CGFloat = 10
        var photoImg = "photo1"
        if (message.fromUser == "you") {
            fromSelf = true
            photoX = self.view.frame.size.width - 60
            photoImg = "photo"
        }
        // 将头像添加进视图
        var photo = UIImageView(frame: CGRectMake(photoX, 10, 50, 50))
        photo.image = UIImage(named: photoImg)
        cell!.addSubview(photo)
        // 消息视图
        var msgView = self.bubbleView(message.body, fromSelf: fromSelf, position: 65)
        if (message.body == "0") {
            msgView = self.voiceView(1, fromSelf: fromSelf, indexRow: indexPath.row, position: 65)
        }
        cell!.addSubview(msgView)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var message = messages[indexPath.row].body
        var size = StringUtils.stringSize(message, size: textSize, fontSize: 13)
        return size.height + 44
    }
    
    // MARK: - BMessageDelegate
    
    func newMessageReceived(message: BJabberMessage) {
        println(message.body)
        // 标题显示输入状态
        if ( message.isComposing ) {
            self.navigationItem.title = "正在输入..."
        } else {
            self.navigationItem.title = chatWithUser
            messages.append(message)
        }
        // 刷新消息
        if ( !message.body.isEmpty ) {
            //self.tbView.reloadData()
            // 动画插入Cell
            var indexPath = NSIndexPath(forRow: messages.count - 1, inSection: 0)
            self.tbView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func xmppStream() -> XMPPStream {
        return self.appDelegate().xmppStream
    }
    
    /**
     * 泡泡文本
     */
    func bubbleView(text: NSString, fromSelf: Bool, position: CGFloat) -> UIView {
        let font = UIFont.systemFontOfSize(13)
        let textAttributes = [ NSFontAttributeName: font ]
        let bubbleSize = text.boundingRectWithSize(textSize, options: .UsesLineFragmentOrigin, attributes: textAttributes, context: nil).size
        
        var bubbleView = UIView(frame: CGRectZero)
        // 背景图片
        var image = fromSelf ? "SenderAppNodeBkg_HL" : "ReceiverTextNodeBkg"
        var bubbleImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(image, ofType: "png")!)!
        bubbleImage = bubbleImage.stretchableImageWithLeftCapWidth(Int(bubbleImage.size.width/2), topCapHeight: Int(bubbleImage.size.height/2))
        
        var bubbleImageView = UIImageView(image: bubbleImage)
        
        // 添加文本信息
        let labelX: CGFloat = fromSelf ? 15 : 22
        let labelY: CGFloat = 15
        let labelW: CGFloat = bubbleSize.width + labelX
        let labelH: CGFloat = bubbleSize.height + labelY
        
        var bubbleLabel = UILabel(frame: CGRectMake(labelX, labelY, labelW, labelH))
        bubbleLabel.backgroundColor = UIColor.clearColor()
        bubbleLabel.font = font
        bubbleLabel.numberOfLines = 0
        bubbleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        bubbleLabel.text = text as String
        
        bubbleImageView.frame = CGRectMake(0, 14, labelX+labelW, labelY+labelH)
        
        var bX: CGFloat = 0.0
        if (fromSelf) {
            bX = self.view.frame.width - position - (labelW + 30.0)
        } else {
            bX = position
        }
        bubbleView.frame = CGRectMake(bX, 0, self.view.frame.size.width-30, labelH)
        bubbleView.addSubview(bubbleImageView)
        bubbleView.addSubview(bubbleLabel)
        println(bubbleView.frame)
        //BViewHelper.addConstants(bubbleView, subViews: ["image":bubbleImageView,"label":bubbleLabel], formats: ["H:|[image]|","V:|[image]|","H:|-15-[label]-15-|","V:|-15-[label]-15-|"])
        
        return bubbleView
    }
    
    /**
    泡泡语音
    
    :param: time     语音时长
    :param: fromSelf 是否来自自己
    :param: indexRow cell位置
    :param: position
    */
    func voiceView(time: Int, fromSelf: Bool, indexRow: Int, var position: CGFloat) -> UIView {
        let voiceWidth: CGFloat = 66
        let voiceHeight: CGFloat = 54
        var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.tag = indexRow
        var bX: CGFloat = 0
        if (fromSelf) {
            position = self.view.frame.width - position - voiceWidth
        }
        button.frame = CGRectMake(position, 10, voiceWidth, voiceHeight)
        
        // image偏移量
        var imageInset = UIEdgeInsets()
        imageInset.top = -10
        imageInset.left = fromSelf ? button.frame.size.width/3 : -button.frame.size.width/3
        button.imageEdgeInsets = imageInset
        
        let image = fromSelf ? "SenderVoiceNodePalying" : "ReceiverVoiceNodePlaying"
        button.setImage(UIImage(named: image), forState: UIControlState.Normal)
        
        var bgImage = UIImage(named: fromSelf ? "SenderVoiceNodeDownloading" : "ReceiverVoiceNodeDownloading")
        bgImage = bgImage?.stretchableImageWithLeftCapWidth(20, topCapHeight: 0)
        button.setBackgroundImage(bgImage, forState: UIControlState.Normal)
        
        var label = UILabel(frame: CGRectMake((fromSelf ? -30 : button.frame.size.width), 0, 30, button.frame.size.height))
        label.text = "\(time)"
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        button.addSubview(label)
        
        return button
    }

    
    @IBAction func sendMessage(sender: AnyObject) {
        var content = self.messageTextField.text
        
        if count(content) > 0 {
            // XMPPFramework主要是通过KissXML来生成XML文件
            // 生成<body>文档
            var body = DDXMLElement.elementWithName(Constant.enBody) as! DDXMLElement
            body.setStringValue(content)
            
            // 生成XML消息文档
            var msg = DDXMLElement.elementWithName(Constant.enMsg) as! DDXMLElement
            // 消息类型
            msg.addAttributeWithName("type", stringValue: "chat")
            // 发送给谁
            msg.addAttributeWithName("to", stringValue: chatWithUser)
            // 由谁发送
            msg.addAttributeWithName("from", stringValue: NSUserDefaults.standardUserDefaults().stringForKey(Constant.udUserId))
            // 组合
            msg.addChild(body)
            
            // 发送消息
            self.xmppStream().sendElement(msg)
            
            self.messageTextField.text = ""
            self.messageTextField.resignFirstResponder()
            
            var message = BJabberMessage()
            message.body = content
            message.fromUser = "you"
            message.time = DateUtils.getCurrentTime()
            messages.append(message)
            // 重新刷新tableView
            self.tbView.reloadData()
        }
    }
    
}
