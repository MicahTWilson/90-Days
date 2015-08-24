//
//  ReminderViewController.swift
//  90 Day
//
//  Created by Micah Wilson on 8/21/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {
    @IBOutlet weak var reminderSegmentControl: MWSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reminderSegmentControl.buttonTitles = ["Su", "M", "Tu", "W", "Th", "F", "Sa"]
        self.reminderSegmentControl.allowMultipleSelection = true
        self.reminderSegmentControl.font = UIFont(name: "Avenir-Light", size: 30)
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
