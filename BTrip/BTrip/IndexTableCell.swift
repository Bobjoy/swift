//
//  IndexTableCell.swift
//  BTrip
//
//  Created by Vetech on 15/6/4.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

protocol IndexTableCellDelegate {
    func monitorAction(sender: UIView?)
}

class IndexTableCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    var data: [String: String]?
    var delegate: IndexTableCellDelegate?
    var index = 0
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        
        setAction()
        
    }
    
//    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
//        CGContextAddEllipseInRect(ctx, CGRectMake(0,0,100,100));
//        CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor);
//        CGContextFillPath(ctx);
//    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
//        if separatorColor != nil {
//            separatorColor = UIColor.clearColor()
//        }
//        // 重新定义样式
//        var context: CGContextRef = UIGraphicsGetCurrentContext()
//        
//        CGContextSetFillColorWithColor(context, separatorColor!.CGColor)
//        CGContextFillRect(context, rect);
//        // 上分割线
//        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
//        CGContextStrokeRect(context, CGRectMake(5, -10, rect.size.width - 10, 5))
//        
//        // 下分割线
//        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
//        CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 5));
        
        var layer = CALayer()
        //设置图层属性
        layer.backgroundColor=UIColor.grayColor().CGColor
        layer.bounds=CGRectMake(8, -1, rect.width-16, rect.height+2);
        //显示位置
        layer.position=CGPointMake(8, -1);
        layer.anchorPoint=CGPointZero;
        layer.cornerRadius=10;
        //添加图层
        self.layer.mask = layer
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 初始化数据
        if let dict = data {
            let bgColor = UIColor.colorWithHexString(dict["bgcolor"]!)
            self.bgImage.image = UIImage(named: dict["image"]!)
            self.view.backgroundColor = bgColor
            self.view.tag = self.index*10+1
            self.label1.text = dict["l1"]
            self.label1.backgroundColor = bgColor
            self.label2.text = dict["l2"]
            self.label2.tag = self.index*10+2
            self.label2.backgroundColor = bgColor
            self.label3.text = dict["l3"]
            self.label3.tag = self.index*10+3
            self.label3.backgroundColor = bgColor
            self.label4.text = dict["l4"]
            self.label4.tag = self.index*10+4
            self.label4.backgroundColor = bgColor
            self.label5.text = dict["l5"]
            self.label5.tag = self.index*10+5
            self.label5.backgroundColor = bgColor
        }
    }
    
    // 绑定手势
    func setAction() {
        var i = 0
        for v in [view, label2, label3, label4, label5] {
            var recognizer = UITapGestureRecognizer(target: self, action: "fireAction:")
            v.userInteractionEnabled = true
            v.addGestureRecognizer(recognizer)
        }
    }
    
    func fireAction(sender: UITapGestureRecognizer) {
        self.delegate?.monitorAction(sender.view)
    }
    
}
