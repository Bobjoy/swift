//
//  BViewHelper.swift
//  BChat
//
//  Created by Vetech on 15/6/25.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class BViewHelper: NSObject {
   
    class func addConstants(superView: UIView, subViews: [String: UIView], formats: [String]) {
        for view in subViews.values {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        for format in formats {
            superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: nil, metrics: nil, views: subViews))
        }
    }
}
