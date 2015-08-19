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
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backNavView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var dailyVC: DailyViewController?
    var objectives = [String]()
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentCourse = course {
            var allTasks = currentCourse.challenges.allObjects as! [Challenge]
            for task in allTasks {
                self.objectives.append(task.task)
            }
            if currentCourse.startDate.compare(NSDate()) == .OrderedAscending {
                self.saveButton.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
                self.saveButton.setTitle("Stop", forState: .Normal)
                self.saveButton.removeTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
                self.saveButton.addTarget(self, action: "stopPressed:", forControlEvents: .TouchUpInside)
                self.saveButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                self.saveButton.layer.borderWidth = 2.0
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func showPopover(sender: UIBarButtonItem) {
        var popover = UIPopoverController(contentViewController: storyboard!.instantiateViewControllerWithIdentifier("popoverView") as! UIViewController)
        popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Up, animated: true)

    }
    
    @IBAction func addObjective(sender: UIBarButtonItem) {
        var alert = UIAlertController(title: "Enter Item", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { void in
            var alertTextField = alert.textFields!.first as! UITextField
            self.objectives.append(alertTextField.text)
            self.table.reloadData()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
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
        
        var totalObjectives = course!.challenges.allObjects as! [Challenge]
        for obj in totalObjectives {
            self.dailyVC?.objectives.append(obj.task)
        }
        self.dailyVC?.table.reloadData()
        self.dailyVC?.calendarViewController?.course = newCourse
        self.dailyVC?.calendarViewController?.datePickerView?.reloadData()
        
        self.saveButton.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.saveButton.setTitle("Stop", forState: .Normal)
    }
    
    func stopPressed(sender: UIButton) {
        println("Stop current challenge")
        self.appDel.managedObjectContext?.deleteObject(self.course!)
        self.appDel.managedObjectContext?.save(nil)
        self.saveButton.backgroundColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.saveButton.setTitle("Save", forState: .Normal)
        self.saveButton.removeTarget(self, action: "stopPressed:", forControlEvents: .TouchUpInside)
        self.saveButton.addTarget(self, action: "savePressed:", forControlEvents: .TouchUpInside)
        self.objectives.removeAll(keepCapacity: false)
        self.table.reloadData()
        self.dailyVC?.turnRed()
        self.dailyVC?.currentCourse = nil
        self.dailyVC?.objectives.removeAll(keepCapacity: false)
        self.dailyVC?.table.reloadData()
        self.dailyVC?.calendarViewController?.course = nil
        self.dailyVC?.calendarViewController?.daysCompleted.removeAll(keepCapacity: false)
        self.dailyVC?.calendarViewController?.datePickerView?.reloadData()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectives.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = objectives[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}