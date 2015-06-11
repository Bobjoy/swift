//
//  MainViewController.swift
//  Vetrip
//
//  Created by Vetech on 15/5/21.
//  Copyright (c) 2015年 Vetech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var scrollImage: UIView!
    
    var collectionView: UICollectionView!
    let identifier : NSString = "CustomCollectionCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var layout = UICollectionViewFlowLayout()
        //布局方向
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical;
        //行间距
        layout.minimumLineSpacing = 5;
        //上,左,下,右边界范围
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        let itemWidth = self.view.frame.width-20
        let itemHeight = (self.view.frame.height-200)/3
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        collectionView = UICollectionView(frame: CGRectMake(0.0, 100.0, self.view.frame.width, self.view.frame.height-150), collectionViewLayout:layout);
        //注册Cell
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addSubview(collectionView);
        
        let views = ["scrollImage": scrollImage, "collectionView": collectionView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollImage]|", options: nil, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: nil, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[scrollImage(==110)]-10-[collectionView]-50-|", options: nil, metrics: nil, views: views))
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let nibName = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.registerNib(nibName, forCellWithReuseIdentifier: identifier)
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as CustomCollectionViewCell
        
        cell.setLabels("酒店", labelText2: "海外", labelText3: "周边", labelText4: "团购・特惠", labelText5: "客栈・公寓")
        cell.setImage("flight.png")
        
        return cell;
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSizeMake(parentSize.width, 60)
    }
    
    
    
}
