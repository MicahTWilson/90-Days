//
//  MWTextField.swift
//  90 Day
//
//  Created by Micah Wilson on 8/20/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit
import QuartzCore

class MWTextView: UITextView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for index in 0..<30 {
            let line = UIView(frame: CGRectMake(5, (CGFloat(index) * (self.font.pointSize + 5.8)) + (self.font.pointSize * 2 - 5), self.frame.width - 10, 1))
            line.backgroundColor = UIColor.lightBlueColor()
            line.alpha = 0.1
            self.addSubview(line)
        }
        
        
        
    }
    
    override func drawRect(rect: CGRect) {

    }
}