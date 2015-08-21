//
//  MWProgressView.swift
//  90 Day
//
//  Created by Micah Wilson on 5/23/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import UIKit
class MWProgressView: UIView {
    var value: Double = 0
    var endingValue: Double = 90
    var progressColor: UInt32 = 0x0F83FF
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clearColor()
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        // Clip
        let cornerRadius = bounds.height * 40 / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        CGContextAddPath(ctx, path.CGPath)
        
        // Fill the track
        CGContextSetFillColorWithColor(ctx, UIColor.subtleGrayColor().CGColor)
        CGContextAddPath(ctx, path.CGPath)
        CGContextFillPath(ctx)
        
        //Fill the highlighted range
        var width = Double(self.bounds.width)
        if self.value < endingValue / 8.2 {
            self.value = endingValue / 8.2
        }
        var track = CGRectMake(2, 2, CGFloat(((self.value)/self.endingValue) * width)-4, self.bounds.height-4)
        let trackPath = UIBezierPath(roundedRect: track, cornerRadius: cornerRadius)
        CGContextAddPath(ctx, trackPath.CGPath)
        CGContextSetFillColorWithColor(ctx, UIColor.fromHex(progressColor, alpha: 1.0).CGColor)
        CGContextAddPath(ctx, trackPath.CGPath)
        CGContextFillPath(ctx)
        
        CGContextStrokePath(ctx)
    }
}
