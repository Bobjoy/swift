//
//  BaseView.swift
//  BTrip
//
//  Created by Vetech on 15/6/9.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

struct Border {
    var width: CGFloat
    var weight: CGFloat
    var color: UIColor
    var type: BorderType
    
    init(width: CGFloat, weight: CGFloat, color: UIColor, type: BorderType){
        self.width = width
        self.weight = weight
        self.color = color
        self.type = type
    }
}

class BaseView: UIView {
    
    // border
    var border: Border?
    var borderLeft: Border?
    var borderRight: Border?
    var borderTop: Border?
    var borderBottom: Border?
    
    override func drawRect(rect: CGRect) {
        if let b = border {
            drawBorder(CGPointMake(0, 0), end: CGPointMake(rect.width, 0), width: b.weight)
            // 左边界
            drawBorder(CGPointMake(0, 0), end: CGPointMake(0, rect.height), width: b.weight)
            
            // 下边界
            drawBorder(CGPointMake(0, rect.height), end: CGPointMake(rect.width, rect.height), width: b.weight)
            // 右边界
            drawBorder(CGPointMake(rect.width, 0), end: CGPointMake(rect.width, rect.height), width: b.weight)
        }else{
            if let bt = borderTop {
                // 上边界
                drawBorder(CGPointMake(0, 0), end: CGPointMake(rect.width, 0), width: bt.weight)
            }
            if let bl = borderLeft {
                // 左边界
                drawBorder(CGPointMake(0, 0), end: CGPointMake(0, rect.height), width: bl.weight)
            }
            if let bb = borderBottom {
                // 下边界
                drawBorder(CGPointMake(0, rect.height), end: CGPointMake(rect.width, rect.height), width: bb.weight)
            }
            if let br = borderRight {
                // 右边界
                drawBorder(CGPointMake(rect.width, 0), end: CGPointMake(rect.width, rect.height), width: br.weight)
            }
        }
        
        super.drawRect(rect)
    }
    
    func drawBorder(start: CGPoint, end: CGPoint, width: CGFloat){
        var context = UIGraphicsGetCurrentContext()
        // 设置线条样式
        CGContextSetLineCap(context, kCGLineCapSquare)
        // 设置线条粗细宽度
        CGContextSetLineWidth(context, width)
        //设置颜色
        UIColor.blueColor().setFill()
        //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, start.x, start.y);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, end.x, end.y);
        //连接上面定义的坐标点
        CGContextStrokePath(context);
    }
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        super.drawLayer(layer, inContext: ctx)
    }
}
