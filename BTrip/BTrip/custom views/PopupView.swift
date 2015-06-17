//
//  PopupView.swift
//  BTrip
//
//  Created by Vetech on 15/6/16.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class PopupView: UIView {
    
    var mQueueCount = 0
    var mTextLabel: UILabel!
    
    var mParentView: UIView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, view: UIView) {
        super.init(frame: frame)
        
        self.mParentView = view
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.layer.cornerRadius = 5.0
        
        mTextLabel = UILabel(frame: CGRectMake(0, 10, 100, 10))
        mTextLabel.numberOfLines = 0
        
        mTextLabel.font = UIFont.systemFontOfSize(17)
        mTextLabel.textColor = UIColor.greenColor()
        
        mTextLabel.textAlignment = NSTextAlignment.Center
        mTextLabel.backgroundColor = UIColor.blackColor()
        mTextLabel.textAlignment = NSTextAlignment.Center
        
        self.addSubview(mTextLabel)
        mQueueCount = 0
        
        var centerPoint = CGPointMake(mParentView.center.x, self.center.y)
        self.center = centerPoint
        
    }
    
    func showText(text: String) {
        mTextLabel.frame = CGRectMake(0, 10, 100, 10)
        mQueueCount++
        self.alpha = 1.0
        mTextLabel.text = text
        mTextLabel.sizeToFit()
        
        var frame: CGRect = CGRectMake(5, 0, mTextLabel.frame.size.width, mTextLabel.frame.size.height)
        mTextLabel.frame = frame
        mTextLabel.frame = CGRectMake(
            mTextLabel.frame.origin.x,
            mTextLabel.frame.origin.y + 10,
            mTextLabel.frame.size.width,
            mTextLabel.frame.size.height
        )
        
        frame = CGRectMake(
            (mParentView.frame.size.width - frame.size.width)/2,
            self.frame.origin.y,
            mTextLabel.frame.size.width + 10,
            mTextLabel.frame.size.height + 20
        )
        self.frame = frame
        
        var centerPoint = CGPointMake(mParentView.center.x, self.center.y)
        self.center = centerPoint
        
        /**
        addSubView 会自动判断是否已经在subviews数组里面
        如果已经在数组里面，就不会再次addSubView
        **/
        if mParentView != NSNull() {
            mParentView.addSubview(self)
        }
        
        UIView.animateWithDuration(3.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.alpha = 0
        }) { (finished) -> Void in
            if self.mQueueCount == 1 {
                self.removeFromSuperview()
            }
            self.mQueueCount--
        }
    }

}
