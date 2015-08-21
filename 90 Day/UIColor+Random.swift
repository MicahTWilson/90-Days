//
//  UIColor+Random.swift
//  RandomMastr
//
//  Created by Micah Wilson on 5/16/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    
    class func darkestBlueColor() -> UIColor {
        return  UIColor(red:0.1, green:0.31, blue:0.52, alpha:1)
    }
    
    class func darkBlueColor() -> UIColor {
        return UIColor(red:0, green:0.39, blue:0.78, alpha:1)
    }
    
    class func mediumBlueColor() -> UIColor {
        return  UIColor(red:0, green:0.53, blue:0.88, alpha:1)
    }
    
    class func lightBlueColor() -> UIColor {
        return  UIColor(red:0, green:0.6, blue:1, alpha:1)
    }
    
    class func lightGreenColor() -> UIColor {
        return UIColor(red:0, green:0.93, blue:0.01, alpha:1)
    }
    
    class func subtleGrayColor() -> UIColor {
        return UIColor(red:0.94, green:0.93, blue:0.93, alpha:1)
    }
    
    class func mediumGrayColor() -> UIColor {
        return UIColor(red:0.25, green:0.25, blue:0.25, alpha:1)
    }
    
    class func darkestGrayColor() -> UIColor {
        return UIColor(red:0.22, green:0.22, blue:0.22, alpha:1)
    }
    
    
    class func tanColor() -> UIColor {
        return  UIColor(red:0.93, green:0.95, blue:0.77, alpha:1)
    }
    
    class func lighterGreenColor() -> UIColor {
        return  UIColor(red:0.29, green:0.67, blue:0.37, alpha:1)
    }
    
    class func lightBrownColor() -> UIColor {
        return UIColor(red:0.73, green:0.59, blue:0.49, alpha:1)
    }
    
    class func lightYellowColor() -> UIColor {
        return UIColor(red:0.91, green:0.87, blue:0.3, alpha:1)
    }
    
    class func fromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}