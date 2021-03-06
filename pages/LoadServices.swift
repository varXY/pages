//
//  LoadServices.swift
//  BaiduMapDemo
//
//  Created by Bobo on 15/12/7.
//  Copyright © 2015年 益行人-星夜暮晨. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AddressBook
import Contacts

class loadServices {
    
    
    class func useAppleMap(toLocation: SearchResult) {
        
        let toNumbers = (Double(toLocation.longitude)!, Double(toLocation.latitude)!)
        let notBaidu = loadServices.changeToGaoDe(toNumbers)
        let coor1 = CLLocationCoordinate2D(latitude: notBaidu.1, longitude: notBaidu.0)
        
        let placemark1 = MKPlacemark(coordinate: coor1, addressDictionary: [CNPostalAddressStreetKey: toLocation.name])
        let toLocation = MKMapItem(placemark: placemark1)
        
        MKMapItem.openMapsWithItems([toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        
        
    }
    
    
    class func getTitleFromURL(url: NSURL) -> String {
        let urlString = url.absoluteString.stringByRemovingPercentEncoding
        var title = ""
        
        if let array = urlString?.componentsSeparatedByString("&") {
            
            for element in array {
                
                if let range = element.rangeOfString("title=") {
                    title = element.stringByReplacingCharactersInRange(range, withString: "")
                    if let range1 = title.rangeOfString("#") {
                        title = title.stringByReplacingCharactersInRange(range1, withString: "")
                    }
                }
                
                if let range = element.rangeOfString("tail=") {
                    title = element.stringByReplacingCharactersInRange(range, withString: "")
                    if let range1 = title.rangeOfString("#") {
                        title = title.stringByReplacingCharactersInRange(range1, withString: "")
                    }
                }
                
                if let range = element.rangeOfString("keyword=") {
                    title = element.stringByReplacingCharactersInRange(range, withString: "")
                    if let range1 = title.rangeOfString("#") {
                        title = title.stringByReplacingCharactersInRange(range1, withString: "")
                    }
                }
                
                if let range = element.rangeOfString("name=") {
                    title = element.stringByReplacingCharactersInRange(range, withString: "")
                    if let range1 = title.rangeOfString("#") {
                        title = title.stringByReplacingCharactersInRange(range1, withString: "")
                    }
                }
                
            }
            
        }
        
        return title
    }
    
    
    class func changeToGaoDe(location: (Double, Double)) -> (Double, Double) {
        
        var returnLocation: (Double, Double) = (0.0, 0.0)
        let x_pi = 3.14159265358979324 * 3000.0 / 180.0
        
        let x = location.0 - 0.0065
        let y = location.1 - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        
        returnLocation.0 = z * cos(theta)
        returnLocation.1 = z * sin(theta)
        
        return returnLocation
    }
    
    class func call(viewController: UIViewController, number: String) {
        let alert = UIAlertController(title: number, message: nil, preferredStyle: .Alert)
        let action1 = UIAlertAction(title: "呼叫", style: .Default) { (_) -> Void in
            
            var phoneNumber = number
            if let bracket = phoneNumber.rangeOfString("(") {
                phoneNumber = phoneNumber.stringByReplacingCharactersInRange(bracket, withString: "")
                if let bracket2 = phoneNumber.rangeOfString(")") {
                    phoneNumber = phoneNumber.stringByReplacingCharactersInRange(bracket2, withString: "")
                }
            }
            
            if let bracket = phoneNumber.rangeOfString("\t") {
                phoneNumber = phoneNumber.stringByReplacingCharactersInRange(bracket, withString: "")
            }
            
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phoneNumber)!)
        }
        let action2 = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func sendText(number: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "sms://" + number)!)
    }

}