//
//  GoalTableCell.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class GoalTableCell: UITableViewCell {
    @IBOutlet weak var goalTitleLabel: UITextField!
    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var reminderButton: UIButton!
    var parentVC: DailyViewController!
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func reminderPressed(sender: UIButton) {
        var reminderVC = self.parentVC.storyboard?.instantiateViewControllerWithIdentifier("reminderVC") as! UIViewController
        reminderVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        reminderVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.parentVC.presentViewController(reminderVC, animated: true, completion: nil)
    }
}