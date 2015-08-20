//
//  MWSegmentedControl.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

@objc protocol MWSegmentedControlDelegate {
    optional func segmentDidChange(control: MWSegmentedControl, value: Int)
}

class MWSegmentedControl: UIView {
    let buttonTitles = ["7", "21", "30", "60", "90"]
    let borderColor = UIColor(red:0.76, green:0.07, blue:0.02, alpha:1)
    let textColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1)
    var delegate: MWSegmentedControlDelegate?
    var value: Int!
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = self.borderColor.CGColor
        self.layer.masksToBounds = true
        
        for (index, button) in enumerate(buttonTitles) {
            let buttonWidth = self.frame.width / CGFloat(buttonTitles.count)
            let buttonHeight = self.frame.height
            
            let newButton = UIButton(frame: CGRectMake(CGFloat(index) * buttonWidth, 0, buttonWidth, buttonHeight))
            newButton.setTitle(button, forState: .Normal)
            newButton.setTitleColor(self.textColor, forState: .Normal)
            newButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 36)
            newButton.addTarget(self, action: "changeSegment:", forControlEvents: .TouchUpInside)
            newButton.layer.borderWidth = 1
            newButton.layer.borderColor = self.borderColor.CGColor
            self.addSubview(newButton)
            
            if index == 2 {
                self.changeSegment(newButton)
            }
        }
    }
    
    func changeSegment(sender: UIButton) {
        
        for subview in self.subviews {
            if subview.isKindOfClass(UIButton) {
                (subview as! UIButton).setTitleColor(self.textColor, forState: .Normal)
                (subview as! UIButton).backgroundColor = UIColor.clearColor()
            }
        }
        
        sender.backgroundColor = borderColor
        sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.value = NSString(string: sender.titleLabel!.text!).integerValue
        self.delegate?.segmentDidChange!(self, value: self.value)
    }
}
