//
//  Test.swift
//  BTrip
//
//  Created by Vetech on 15/6/11.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation
import UIKit

let size = CGSize(width: 280, height: Int.max)
let options: NSStringDrawingOptions = .UsesLineFragmentOrigin | .UsesFontLeading

class MusicViewController: UIViewController {
    
}

class AlbumViewController: UIViewController {
    
}

let useringVCTypes: [AnyClass] = [MusicViewController.self, AlbumViewController.self]

func setupViewControllers(vcTypes: [AnyClass]) {
    for vcType in vcTypes {
        if vcType is UIViewController.Type {
            let vc = (vcType as! UIViewController.Type).`new`()
            println(vc)
        }
    }
}