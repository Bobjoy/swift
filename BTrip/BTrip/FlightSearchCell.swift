//
//  FlightSearcCell.swift
//  BTrip
//
//  Created by Vetech on 15/6/9.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit

enum BorderType {
    case None,Hidden,Dotted,Dashed,Solid,Double
}

class FlightSearchCell: UITableViewCell {
    
    @IBOutlet weak var mNameLabel: UILabel!
    @IBOutlet weak var mValueLabel: UILabel!
    
    var margin: UIEdgeInsets?
    var cntView: UIView!
    var bgColor: UIColor!{
        didSet{
            cntView.backgroundColor = bgColor
        }
    }
    var radius: CGFloat = 0.0{
        didSet{
            cntView.layer.cornerRadius = radius
        }
    }
    var accessory: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cntView = BaseView(frame: CGRectZero)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        super.drawLayer(layer, inContext: ctx)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawContentView()
    }
    
    func drawContentView(){
        // 设置宽高
        let width = self.frame.width
        let height = self.frame.height
        cntView.frame = CGRectMake(0,0,width, height)
        // 设置Margin
        if let mrg = self.margin {
            cntView.frame = CGRectMake(
                mrg.left,
                mrg.top,
                width - ( mrg.left + mrg.right),
                height - ( mrg.top + mrg.bottom )
            )
        }
        // 设置圆角
        cntView.layer.cornerRadius = radius
        // 设置向右的箭头
        if accessory == true {
            var arrow = UIImageView(image: UIImage(named: "arrow_right.png"))
            cntView.addSubview(arrow)
            arrow.setTranslatesAutoresizingMaskIntoConstraints(false)
            cntView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[arrow]-16-|", options: nil, metrics: nil, views: ["arrow":arrow]))
            cntView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\((cntView.frame.height-arrow.frame.height)/2.0)-[arrow]", options: nil, metrics: nil, views: ["arrow":arrow]))
        }
        self.contentView.addSubview(cntView)
        // 将试图放到最下层
        self.contentView.sendSubviewToBack(cntView)
    }
    
}
