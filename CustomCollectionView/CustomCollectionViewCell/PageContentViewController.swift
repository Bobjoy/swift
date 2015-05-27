//
//  PageContentViewController.swift
//  Vetrip
//
//  Created by Vetech on 15/5/21.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var pageIndex: Int = 0
    var titleText: String!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: self.imageFile)
        self.titleLabel.text = self.titleText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
