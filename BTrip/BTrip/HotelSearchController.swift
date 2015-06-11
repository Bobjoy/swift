//
//  HotelSearchController.swift
//  BTrip
//
//  Created by Vetech on 15/6/10.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import UIKit
import CoreLocation

class HotelSearchController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var jd: UILabel!
    @IBOutlet weak var wd: UILabel!
    @IBOutlet weak var gd: UILabel!
    
    var locationManager: CLLocationManager!
    var currLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
        locationManager.requestAlwaysAuthorization()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currLocation = locations.last as! CLLocation
        var coordinate = currLocation.coordinate
        jd.text = "\(coordinate.longitude)"
        wd.text = "\(coordinate.latitude)"
        gd.text = "\(currLocation.altitude)"
        
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
            for place in placemarks {
                println(place)
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        
        if let clErr = CLError(rawValue: error.code) {
            switch clErr {
            case .LocationUnknown:
                println("位置不明")
            case .Denied:
                println("允许检索位置被拒绝")
            case .Network:
                println("用于检索位置的网络不可用")
            default:
                println("未知错误")
            }
        } else {
            println("其他错误")
            let alert = UIAlertView(title: "提示信息", message: "定位失败", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    
    @IBAction func locate(sender: AnyObject) {
        var geocoder = CLGeocoder()
        var p: CLPlacemark?
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
           var array = NSArray(object: "zh-hans")
            NSUserDefaults.standardUserDefaults().setObject(array, forKey: "AppleLanguages")
            if error != nil {
                println("reverse geocode fail: \(error.localizedDescription)")
                return
            }
            let pm = placemarks as! [CLPlacemark]
            if pm.count > 0 {
                p = placemarks[0] as? CLPlacemark
                println(p)
            } else {
                println("No Placemarks")
            }
        })
    }

}
