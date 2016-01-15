//
//  UIImage+ColorImage.swift
//  HEICHE
//
//  Created by Bobo on 15/12/18.
//  Copyright © 2015年 farawei. All rights reserved.
//

import Foundation
import UIKit

typealias finished = (UIImage) -> Void

extension UIImage {
    
    class func imageWithColor(color: UIColor, rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func imageWithURL(url: NSURL, done: finished) {
        
        let session = NSURLSession.sharedSession()
        
        session.downloadTaskWithURL(url, completionHandler: { url, response, error in
            if error == nil && url != nil {
                if let data = NSData(contentsOfURL: url!) {
                    if let image = UIImage(data: data) {
                        dispatch_async(dispatch_get_main_queue()) {
                            done(image)
                        }
                    }
                }
            }
            })
        
    }
}