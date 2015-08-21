//
//  CampaignCollectionCell.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class CampaignCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var goalsTable: UITableView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var campaignLengthLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var campaign: Course!
    var parentVC: SettingsViewController!
    var indexPath: NSIndexPath!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return campaign.challenges.count + 1
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let goalsHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, tableView.sectionHeaderHeight))
            goalsHeaderView.addSubview(self.headerView)
            self.headerView.center = goalsHeaderView.center
            return goalsHeaderView
        } else {
            let emptyHeader = UIView(frame: CGRectMake(0, 0, tableView.frame.width, tableView.sectionHeaderHeight))
            emptyHeader.backgroundColor = UIColor.clearColor()
            return emptyHeader
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let graphCell = tableView.dequeueReusableCellWithIdentifier("graphCell") as! GraphTableCell
            graphCell.campaign = self.campaign
            return graphCell
        }
        
        if indexPath.row == campaign.challenges.count {
            let addCell = tableView.dequeueReusableCellWithIdentifier("addCell") as! UITableViewCell
            
            return addCell
        } else {
            let goalCell = tableView.dequeueReusableCellWithIdentifier("goalCell") as! GoalTableCell
            goalCell.goalTitleLabel.text = self.campaign.goals[indexPath.row].task
            goalCell.goalTitleLabel.tag = indexPath.row
            
            //Configure goal statistics for campaign
            let totalDaysIntoCampaign = (NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: self.campaign.startDate, toDate: NSDate(), options: NSCalendarOptions.allZeros)).day + 1
            let totalDaysCompleted = self.campaign.goals[indexPath.row].daysCompleted.count
            
            let score = Int(round((Double(totalDaysCompleted) / Double(totalDaysIntoCampaign)) * 100))
            goalCell.scoreLabel.text = "%\(score)"
            
            if score >= 85 {
                goalCell.scoreLabel.textColor = UIColor(red:0.01, green:0.82, blue:0.29, alpha:1)
            } else if score < 85 && score > 65 {
                goalCell.scoreLabel.textColor = UIColor(red:1, green:0.64, blue:0.02, alpha:1)
            } else {
                goalCell.scoreLabel.textColor = UIColor.fromHex(0xD02802, alpha: 1.0)
            }
            
            return goalCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 164
        } else {
            return 49
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.endEditing(true)

        if indexPath.row == campaign.challenges.count {
            var allGoals = self.campaign.goals
            allGoals.append(Challenge.addChallenge("", context: appDel.managedObjectContext!, error: nil))
            campaign.challenges = NSSet(array: allGoals)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
            (tableView.cellForRowAtIndexPath(indexPath) as! GoalTableCell).goalTitleLabel.becomeFirstResponder()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row != self.campaign.goals.count {
            return true
        } else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var allGoals = self.campaign.goals
        Challenge.deleteObject(allGoals[indexPath.row], context: appDel.managedObjectContext!, error: nil)
        allGoals.removeAtIndex(indexPath.row)
        self.campaign.challenges = NSSet(array: allGoals)
        
        self.appDel.managedObjectContext!.save(nil)
        
        self.goalsTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        for index in indexPath.row..<self.campaign.goals.count {
            self.goalsTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: .Top)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        parentVC.objectivesView.contentInset = UIEdgeInsetsMake(0, 0, 230, 0)
        parentVC.objectivesView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        parentVC.objectivesView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        parentVC.objectivesView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        
        if textField.text == "" {
            //Remove cell from tableView because goal has no content
            var allGoals = self.campaign.goals
            Challenge.deleteObject(allGoals[textField.tag], context: appDel.managedObjectContext!, error: nil)
            allGoals.removeAtIndex(textField.tag)
            self.campaign.challenges = NSSet(array: allGoals)
            
            self.appDel.managedObjectContext?.save(nil)
            
            self.goalsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: textField.tag, inSection: 1)], withRowAnimation: .Top)
            for index in textField.tag..<self.campaign.challenges.count {
                self.goalsTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: .Top)
            }
        } else {
            self.campaign.goals[textField.tag].task = textField.text
            self.appDel.managedObjectContext?.save(nil)
        }
        self.parentVC.dailyVC.table.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
