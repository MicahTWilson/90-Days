//
//  CampaignCollectionCell.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class CampaignCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var campaignLengthLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var campaign: Course!
    var parentVC: SettingsViewController!
    var indexPath: NSIndexPath!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaign.challenges.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == campaign.challenges.count {
            let addCell = tableView.dequeueReusableCellWithIdentifier("addCell") as! UITableViewCell
            
            return addCell
        } else {
            let goalCell = tableView.dequeueReusableCellWithIdentifier("goalCell") as! GoalTableCell
            goalCell.goalTitleLabel.text = (campaign.challenges.allObjects as! [Challenge])[indexPath.row].task
            goalCell.goalTitleLabel.tag = indexPath.row
            
            return goalCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == campaign.challenges.count {
            var allGoals = campaign.challenges.allObjects
            allGoals.append(Challenge.addChallenge("", context: appDel.managedObjectContext!, error: nil))
            campaign.challenges = NSSet(array: allGoals)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
            (tableView.cellForRowAtIndexPath(indexPath) as! GoalTableCell).goalTitleLabel.becomeFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        parentVC.objectivesView.contentInset = UIEdgeInsetsMake(0, 0, 230, 0)
        parentVC.objectivesView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        parentVC.objectivesView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        parentVC.objectivesView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        //TODO: Save challenge at textField.tag as index.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
