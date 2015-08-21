//
//  MWGraphView.swift
//  90 Day
//
//  Created by Micah Wilson on 8/21/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit
import QuartzCore

class MWGraphView: UIView {
    var campaign: Course!
    var tickLabels = [UILabel]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0..<10 {
            let spacing = (self.frame.height - 10) / 10
            let percentLabel = UILabel(frame: CGRectMake(0, CGFloat(index) * spacing, 20, 8))
            percentLabel.font = UIFont(name: "Avenir-Light", size: 8)
            percentLabel.textAlignment = .Right
            percentLabel.text = "%\((10-index) * 10)"
            percentLabel.textColor = UIColor.darkestGrayColor()
            self.addSubview(percentLabel)
        }
        
        for index in 0..<Int(self.campaign.length) {
            let spacing = (self.frame.width - 40) / CGFloat(self.campaign.length)
            let timeLabel = UILabel(frame: CGRectMake(25 + (CGFloat(index) * spacing), self.frame.height - 4, spacing, 8))
            timeLabel.font = UIFont(name: "Avenir-Light", size: 8)
            timeLabel.textAlignment = .Center
            timeLabel.text = "/"
            timeLabel.textColor = UIColor.darkestGrayColor()
            self.addSubview(timeLabel)
            self.tickLabels.append(timeLabel)
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        let cntx = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(cntx, UIColor.lightGrayColor().CGColor)
        
        CGContextSetLineWidth(cntx, 1)
        CGContextMoveToPoint(cntx, 24, 0)
        CGContextAddLineToPoint(cntx, 24, self.frame.height - 6)
        
        CGContextMoveToPoint(cntx, 24, self.frame.height - 6)
        CGContextAddLineToPoint(cntx, self.frame.width - 14, self.frame.height - 6)
        CGContextStrokePath(cntx)
        
        for dayIndex in 0..<Int(self.campaign.length) {
            let spacing = (self.frame.width - 70) / CGFloat(self.campaign.length)
            let height = self.frame.height - CGFloat(6.5)
            
            CGContextSetStrokeColorWithColor(cntx, UIColor.subtleGrayColor().CGColor)
            CGContextSetLineWidth(cntx, spacing)
            CGContextMoveToPoint(cntx, tickLabels[dayIndex].center.x, self.frame.height - 6.5)
            
            var progress: CGFloat = 0
            for goal in self.campaign.challenges.allObjects as! [Challenge] {
                for (index, dayComplete) in enumerate(goal.daysCompleted.allObjects as! [CompletionProgress]) {
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let completed = dayComplete.dateCompleted {
                        if dateFormatter.stringFromDate(dayComplete.dateCompleted!) == dateFormatter.stringFromDate(self.campaign.startDate.dateByAddingTimeInterval(NSTimeInterval(dayIndex)*24*60*60)) {
                            //Goal has been completed. Update Count.
                            progress += 1
                        }
                    }
                }
            }
            
            progress = (progress / CGFloat(self.campaign.challenges.count) * 100)
            
            if progress >= 85 {
                CGContextSetStrokeColorWithColor(cntx, UIColor(red:0.01, green:0.82, blue:0.29, alpha:1).CGColor)
            } else if progress < 85 && progress > 65 {
                CGContextSetStrokeColorWithColor(cntx, UIColor(red:1, green:0.64, blue:0.02, alpha:1).CGColor)
            } else {
                CGContextSetStrokeColorWithColor(cntx, UIColor.fromHex(0xD02802, alpha: 1.0).CGColor)
            }
            
            let barHeight = height * (progress / 100)
            
            CGContextAddLineToPoint(cntx, tickLabels[dayIndex].center.x, height - barHeight)
            CGContextStrokePath(cntx)
        }
        
    }
}
