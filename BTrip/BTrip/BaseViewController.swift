//
//  BaseViewController.swift
//  BTrip
//
//  Created by Vetech on 15/6/5.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var notiName = "btrip_notification"
    var hideNav = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexString("#F2F2F2")
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = hideNav
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = hideNav
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func autolayout(view: UIView, views: [String: UIView], formats: [String]){
        for v in views.values {
            v.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        for format in formats {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: nil, metrics: nil, views: views))
        }
    }
    // 监听通知
    func addObserver(selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notiName, object: nil)
    }
    // 移除通知
    func removeObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: notiName, object:nil)
    }
    // 图片等比例缩放
    func filledImage(view: UIView, image: UIImage?) -> UIImage? {
        var scaledImage = UIImage()
        var width = view.frame.width
        var height = view.frame.height
        if let img = image where width != 0 && height != 0 {
            var imgSize = img.size
            // 缩放比例
            var scale = width/((imgSize.width == 0) ? 1 : imgSize.width)
            var targetWidth = width
            var targetHeight = imgSize.height*scale
            
            UIGraphicsBeginImageContext(CGSizeMake(imgSize.width * scale, imgSize.height * scale))
            img.drawInRect(CGRectMake(0, 0, imgSize.width * scale, imgSize.height * scale))
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if scaledImage == NSNull() {
                scaledImage = UIImage()
            }
            return scaledImage
        }
        return scaledImage
    }
    
    func dlog(message: String="", file: String=__FILE__, function: String=__FUNCTION__, lineNum: Int=__LINE__) {
        #if DEBUG
            println("FILE: \(file.pathComponents.last!),FUNC: \(function),LINE: \(lineNum),MESSAGE: \(message)")
        #endif
    }

}
