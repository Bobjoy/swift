//
//  MessageTableViewCell.swift
//  BChat
//
//  Created by Vetech on 15/6/18.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var senderAndTimeLabel: UILabel!
    var messageContentView: UITextView!
    var bgImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 日期标签
        senderAndTimeLabel = UILabel(frame: CGRectMake(10, 5, 300, 20))
        // 居中显示
        senderAndTimeLabel.textAlignment = NSTextAlignment.Center
        senderAndTimeLabel.font = UIFont.systemFontOfSize(11)
        // 文字颜色
        senderAndTimeLabel.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(senderAndTimeLabel)
        
        // 背景图片
        bgImageView = UIImageView(frame: CGRectZero)
        self.contentView.addSubview(bgImageView)
        
        // 聊天信息
        messageContentView = UITextView()
        messageContentView.backgroundColor = UIColor.clearColor()
        messageContentView.editable = false
        messageContentView.scrollEnabled = false
        messageContentView.sizeToFit()
        self.contentView.addSubview(messageContentView)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
