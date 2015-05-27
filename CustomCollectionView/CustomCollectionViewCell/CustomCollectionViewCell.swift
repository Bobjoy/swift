//
//  VetripCollectionViewCell.swift
//  Vetrip
//
//  Created by Vetech on 15/5/27.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLabels(labelText1: String, labelText2: String, labelText3: String, labelText4: String, labelText5: String) {
        self.label1.text = labelText1
        self.label2.text = labelText2
        self.label3.text = labelText3
        self.label4.text = labelText4
        self.label5.text = labelText5
    }
    
    func setImage(image: String) {
        self.imageView.image = UIImage(named: image)
    }

}
