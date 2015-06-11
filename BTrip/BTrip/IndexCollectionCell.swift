//
//  VetripCollectionViewCell.swift
//  Vetrip
//
//  Created by Vetech on 15/5/27.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import UIKit

typealias Callback = (sender: AnyObject) -> ()

class IndexCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var callback: Callback?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
    初始化cell: 设置标签文本，图像，背景颜色，点击手势
    
    :param: data   数据
    :param: action 点击执行的方法
    
    :returns:
    */
    func initCell(index: Int, data: [String], callback: (sender: AnyObject) -> ()) {
        self.callback = callback
        
        imageView.image = UIImage(named: data[0])
        label1.text = data[1]
        label2.text = data[2]
        label3.text = data[3]
        label4.text = data[4]
        label5.text = data[5]
        // 设置cell背景
        setColor(data[6])
        // view添加手势
        setAction(index)
    }
    
    /**
    设置view的北京颜色
    
    :param: hexColor 16进制的颜色, eg: #FFFFFF
    */
    func setColor(hexColor: NSString) {
        let color = UIColor.colorWithHexString(hexColor)
        view.backgroundColor = color
        label1.backgroundColor = color
        label2.backgroundColor = color
        label3.backgroundColor = color
        label4.backgroundColor = color
        label5.backgroundColor = color
    }
    
    func setAction(index: Int) {
        var i = 0
        for v in [view,label2,label3,label4,label5] {
            var tap = UITapGestureRecognizer(target: self, action: "fireAction:")
            v.tag = "\(index+1)\(++i)".toInt()!
            v.addGestureRecognizer(tap)
        }
    }

    func fireAction(sender: AnyObject){
        if let cb = callback {
            cb(sender: sender)
        }
    }
}
