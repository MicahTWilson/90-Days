//
//  CampaignViewController.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit
class CampaignViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MWSegmentedControlDelegate {
    @IBOutlet weak var goalsTable: UITableView!
    @IBOutlet weak var campaignLengthControl: MWSegmentedControl!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var parentVC: SettingsViewController!
    var goals = [String]()
    var campaignLength = 0
    var campaignStartDate = NSDate()
    var currentCampaign: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.enabled = false
        self.saveButton.alpha = 0.5
        
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        
        if let campaign = currentCampaign {
            self.dateButton.setTitle(formatter.stringFromDate(campaign.startDate.dateByAddingTimeInterval(NSTimeInterval(campaign.length)*24*60*60)), forState: .Normal)
        } else {
            self.dateButton.setTitle(formatter.stringFromDate(NSDate()), forState: .Normal)
        }
        
        self.campaignLengthControl.delegate = self
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cancelPressed"))
    }
    
    @IBAction func saveCampaignPressed(sender: UIButton) {
        var error: NSError?
        let newCourse = Course.addNewCourse(self.campaignLength, startDate: self.campaignStartDate, goals: self.goals, context: appDel.managedObjectContext!, error: &error)
        if let err = error {
            println("Error occurred: \(err)")
        }
        self.parentVC.campaigns.append(newCourse)
        self.parentVC.objectivesView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func datePressed(sender: UIButton) {
        if let campaign = currentCampaign {
            self.datePicker.minimumDate = campaign.startDate.dateByAddingTimeInterval(NSTimeInterval(campaign.length)*24*60*60)
        } else {
            self.datePicker.minimumDate = NSDate()
        }
        self.datePickerView.hidden = false
        self.datePickerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissDatePicker"))
    }
    
    @IBAction func dateChanged(sender: AnyObject) {
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        self.dateButton.setTitle(formatter.stringFromDate(self.datePicker.date), forState: .Normal)
        self.campaignStartDate = self.datePicker.date
    }
    
    func dismissDatePicker() {
        self.datePickerView.hidden = true
    }
    
    func segmentDidChange(control: MWSegmentedControl, value: Int) {
        self.campaignLength = value
        println("Campaign Length Changed To: \(value) Days")
    }
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: TableView Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goals.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == goals.count {
            let addCell = tableView.dequeueReusableCellWithIdentifier("addCell") as! UITableViewCell
            
            return addCell
        } else {
            let editCell = tableView.dequeueReusableCellWithIdentifier("editCell") as! EditTableCell
            editCell.editField.text = goals[indexPath.row]
            editCell.editField.tag = indexPath.row
            
            return editCell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == goals.count {
            self.goals.append("")
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
            (tableView.cellForRowAtIndexPath(indexPath) as! EditTableCell).editField.becomeFirstResponder()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row != self.goals.count {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.goals.removeAtIndex(indexPath.row)
        self.goalsTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        for index in indexPath.row..<self.goals.count {
            self.goalsTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
        }
        if self.goals.count == 0 {
            self.saveButton.enabled = false
            self.saveButton.alpha = 0.5
        }
    }
    
    //MARK: TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.goalsTable.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        self.goalsTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        if textField.text == "" {
            //Remove cell from tableView because goal has no content
            self.goals.removeAtIndex(textField.tag)
            self.goalsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: textField.tag, inSection: 0)], withRowAnimation: .Top)
            for index in textField.tag..<self.goals.count {
                self.goalsTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Top)
            }
            if self.goals.count == 0 {
                self.saveButton.enabled = false
                self.saveButton.alpha = 0.5
            }
        } else {
            //Set the goal to the text
            self.goals[textField.tag] = textField.text
            
            self.saveButton.enabled = true
            self.saveButton.alpha = 1.0
        }
    }
}
