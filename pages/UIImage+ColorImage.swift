//
//  UIImage+ColorImage.swift
//  HEICHE
//
//  Created by Bobo on 15/12/18.
//  Copyright © 2015年 farawei. All rights reserved.
//

import Foundation
import UIKit

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
}