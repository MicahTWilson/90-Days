//
//  SettingsViewController.swift
//  90 Day
//
//  Created by Micah Wilson on 5/23/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class SettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backNavView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var objectivesView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var campaigns = [Course]()
    var dailyVC: DailyViewController!
    var objectives = [String]()
    var course: Course?
    var selectedIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSFetchRequest(entityName: "Course")
        self.campaigns = appDel.managedObjectContext!.executeFetchRequest(request, error: nil) as! [Course]
        self.objectivesView.reloadData()
        
        
        if let currentCourse = course {
            var allTasks = currentCourse.challenges.allObjects as! [Challenge]
            for task in allTasks {
                self.objectives.append(task.task)
            }
            if currentCourse.startDate.compare(NSDate()) == .OrderedAscending {
//                self.saveButton.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
//                self.saveButton.setTitle("Stop", forState: .Normal)
//                self.saveButton.removeTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
//                self.saveButton.addTarget(self, action: "stopPressed:", forControlEvents: .TouchUpInside)
//                self.saveButton.layer.borderColor = UIColor.lightGrayColor().CGColor
//                self.saveButton.layer.borderWidth = 2.0
            }
        }
        
        let leftGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "swipeScreens:")
        leftGesture.edges = UIRectEdge.Left
        let rightGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "swipeScreens:")
        rightGesture.edges = UIRectEdge.Right
        self.view.addGestureRecognizer(leftGesture)
        self.view.addGestureRecognizer(rightGesture)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func swipeScreens(gesture: UIScreenEdgePanGestureRecognizer) {
        
        if gesture.edges == .Left {
        
            self.dailyVC.view.transform = CGAffineTransformMakeTranslation(gesture.translationInView(self.view).x - self.view.frame.width, 0)
            self.dailyVC.calendarButton.transform = CGAffineTransformMakeTranslation(-gesture.translationInView(self.view).x + self.view.frame.width, 0)
            self.dailyVC.checkAllButton.transform = CGAffineTransformMakeTranslation(-gesture.translationInView(self.view).x + self.view.frame.width, 0)
            self.dailyVC.settingsButton.transform = CGAffineTransformMakeTranslation(-gesture.translationInView(self.view).x + self.view.frame.width, 0)
            
            if gesture.state == .Ended {
                if gesture.translationInView(self.view).x < self.view.frame.width / 2 {
                    self.dailyVC.settingsPressed(self.dailyVC.settingsButton)
                    
                }else {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.dailyVC.checkAllPressed(self.dailyVC.checkAllButton)
                    })
                }
            }
        }
    }
    
    @IBAction func showPopover(sender: UIBarButtonItem) {
        var popover = UIPopoverController(contentViewController: storyboard!.instantiateViewControllerWithIdentifier("popoverView") as! UIViewController)
        popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Up, animated: true)

    }
    
    @IBAction func addObjective(sender: UIBarButtonItem) {
        var newCampaignVC = storyboard?.instantiateViewControllerWithIdentifier("newCampaignView") as! CampaignViewController
        newCampaignVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        newCampaignVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        newCampaignVC.parentVC = self
        newCampaignVC.currentCampaign = self.course
        self.presentViewController(newCampaignVC, animated: true, completion: nil)
        
        
//        var alert = UIAlertController(title: "Enter Item", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addTextFieldWithConfigurationHandler(nil)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { void in
//            var alertTextField = alert.textFields!.first as! UITextField
//            self.objectives.append(alertTextField.text)
//            self.objectivesView.reloadData()
//        }))
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func savePressed(sender: UIButton) {
        var error: NSError?
        var course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: appDel.managedObjectContext!) as! Course
        course.startDate = datePicker.date
        var tasks = [Challenge]()
        for objective in self.objectives {
            var obj = NSEntityDescription.insertNewObjectForEntityForName("Challenge", inManagedObjectContext: appDel.managedObjectContext!) as! Challenge
            obj.task = objective
            appDel.managedObjectContext!.save(&error)
            if let err = error {
                println(err)
            }
            tasks.append(obj)
        }
        course.challenges = NSSet(array: tasks)
        appDel.managedObjectContext!.save(&error)
        if let err = error {
            println(err)
        }
        self.refreshApplication(course)
        GoogleWearAlert.showAlert(title: "Saved", type: .Success)
        self.saveButton.removeTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
        self.saveButton.addTarget(self, action: "stopPressed:", forControlEvents: .TouchUpInside)
    }
    
    func refreshApplication(newCourse: Course) {
        self.dailyVC?.currentCourse = newCourse
        self.course = newCourse
            
        self.dailyVC?.table.reloadData()
        self.dailyVC?.calendarViewController?.course = newCourse
        self.dailyVC?.calendarViewController?.datePickerView?.reloadData()
    }
    
    func stopPressed(sender: UIButton) {
        println("Stop current challenge")
        self.appDel.managedObjectContext?.deleteObject(self.course!)
        self.appDel.managedObjectContext?.save(nil)
        self.objectives.removeAll(keepCapacity: false)
        //self.table.reloadData()
        self.dailyVC?.turnRed()
        self.dailyVC?.currentCourse = nil
        self.dailyVC?.table.reloadData()
        self.dailyVC?.calendarViewController?.course = nil
        self.dailyVC?.calendarViewController?.daysCompleted.removeAll(keepCapacity: false)
        self.dailyVC?.calendarViewController?.datePickerView?.reloadData()
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "campaignHeader", forIndexPath: indexPath) as! UICollectionReusableView
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let campaignCell = collectionView.dequeueReusableCellWithReuseIdentifier("campaignCell", forIndexPath: indexPath) as! CampaignCollectionCell
        
        //Layout Cell
        campaignCell.layer.cornerRadius = 10.0
        campaignCell.layer.borderWidth = 1
        campaignCell.layer.borderColor = UIColor.lightBlueColor().CGColor
        campaignCell.layer.masksToBounds = true
        campaignCell.layer.shadowColor = UIColor.blackColor().CGColor
        campaignCell.layer.shadowOpacity = 0.3
        campaignCell.layer.shadowRadius = 4
        campaignCell.layer.shadowOffset = CGSizeMake(0, 0)
        campaignCell.indexPath = indexPath
        campaignCell.parentVC = self
        
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        
        campaignCell.startLabel.text = formatter.stringFromDate(campaigns[indexPath.row].startDate)
        campaignCell.endLabel.text = formatter.stringFromDate(campaigns[indexPath.row].startDate.dateByAddingTimeInterval(NSTimeInterval(campaigns[indexPath.row].length)*24*60*60))
        campaignCell.campaignLengthLabel.text = "\(campaigns[indexPath.row].length)"
        campaignCell.campaign = campaigns[indexPath.row]
        
        //Configure Campaign Score
        let goals = campaigns[indexPath.row].challenges.allObjects as! [Challenge]
        let totalGoals = goals.count
        var completedDays = 0
        for goal in goals {
            for dayCompleted in goal.daysCompleted.allObjects as! [CompletionProgress] {
                if let completed = dayCompleted.dateCompleted {
                    completedDays++
                }
            }
        }
        
        let totalDaysIntoCampaign = (NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: campaigns[indexPath.row].startDate, toDate: NSDate(), options: NSCalendarOptions.allZeros)).day + 1
        
        let score = Double(completedDays) / (Double(totalGoals) * Double(totalDaysIntoCampaign))
        
        if Int(round(score * 100)) < 65 {
            campaignCell.scoreLabel.textColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        } else if Int(round(score * 100)) > 65 && Int(round(score * 100)) < 85 {
            campaignCell.scoreLabel.textColor = UIColor(red:1, green:0.64, blue:0.02, alpha:1)
        } else {
            campaignCell.scoreLabel.textColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        }
        
        campaignCell.scoreLabel.text = "%\(Int(round(score * 100)))"
        campaignCell.goalsTable.reloadData()
        return campaignCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        if self.selectedIndex == indexPath {
            self.selectedIndex = nil
            
           UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                
                collectionView.cellForItemAtIndexPath(indexPath)!.frame.size = CGSizeMake(349, 89)
            
            
            }, completion: { (finished) -> Void in
                self.objectivesView.collectionViewLayout.invalidateLayout()
            })
            
            return
        }
        
        self.selectedIndex = indexPath
        self.objectivesView.collectionViewLayout.invalidateLayout()
        collectionView.cellForItemAtIndexPath(indexPath)!.frame.size = CGSizeMake(349, 89)
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            collectionView.cellForItemAtIndexPath(indexPath)!.frame.size = CGSizeMake(349, 432)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
        }) { (finished) -> Void in
            self.objectivesView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        if let selected = self.selectedIndex {
            return 100
        }
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let selected = selectedIndex {
            if selected == indexPath {
                return CGSizeMake(349, 432)
            }
        }
        return CGSizeMake(349, 89)
    }
}