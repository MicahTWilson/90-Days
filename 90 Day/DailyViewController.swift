//
//  ViewController.swift
//  90 Day
//
//  Created by Micah Wilson on 5/23/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//
import Foundation
import UIKit
import CoreData
class DailyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var backNavView: UIView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var checkAllButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: MWProgressView!
    @IBOutlet weak var table: UITableView!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var currentDate = NSDate()
    var settingsViewController: SettingsViewController?
    var calendarViewController: CalendarViewController?
    var objectives = [String]()
    var currentCourse: Course?
    var checkAll = true
    var dayCompleted = false
    let blurView = DynamicBlurView(frame: CGRectZero)
    var undoView = UIView(frame: CGRectZero)
    var allDaysPassed = [CompletionProgress]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        self.navBar.topItem?.title = formatter.stringFromDate(currentDate)
        self.nextButton.enabled = false
        
        var request = NSFetchRequest(entityName: "Course")
        var courses = appDel.managedObjectContext?.executeFetchRequest(request, error: nil) as! [Course]
        if let course = courses.first {
            self.currentCourse = course
            var totalObjectives = course.challenges.allObjects as! [Challenge]
            for obj in totalObjectives {
                self.objectives.append(obj.task)
            }
        }
        
        if let course = self.currentCourse {
            self.allDaysPassed = self.currentCourse!.daysCompleted.allObjects as! [CompletionProgress]
        }
        
        
        self.settingsViewController = storyboard!.instantiateViewControllerWithIdentifier("settingsViewController") as? SettingsViewController
        self.settingsViewController?.course = currentCourse
        self.settingsViewController?.dailyVC = self
        self.view.addSubview(self.settingsViewController!.view)
        self.view.sendSubviewToBack(self.settingsViewController!.view)
        self.settingsViewController!.view.userInteractionEnabled = true
        self.settingsViewController!.view.frame = CGRectMake(self.view.frame.width, 0, self.view.frame.width, self.view.frame.height)
        
        self.calendarViewController = storyboard!.instantiateViewControllerWithIdentifier("calendarViewController") as? CalendarViewController
        self.calendarViewController?.course = currentCourse
        self.calendarViewController?.daysCompleted = self.allDaysPassed
        self.view.addSubview(self.calendarViewController!.view)
        self.view.sendSubviewToBack(self.calendarViewController!.view)
        self.calendarViewController!.view.userInteractionEnabled = true
        self.calendarViewController!.view.frame = CGRectMake(-self.view.frame.width, 0, self.view.frame.width, self.view.frame.height)
        
        self.blurView.frame = self.view.bounds
        self.blurView.blurRadius = 0.0
        var undoButton = UIButton(frame: CGRectMake(0, 20, self.view.frame.width, 44))
        undoButton.setTitle("Undo This Days Progress", forState: .Normal)
        undoButton.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        undoButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 22)
        undoButton.addTarget(self, action: "resetDay", forControlEvents: .TouchUpInside)
        self.undoView.frame = CGRectMake(0, -64, self.view.bounds.width, 64)
        self.undoView.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.undoView.addSubview(undoButton)
        self.blurView.addSubview(undoView)
        self.blurView.userInteractionEnabled = true
        self.view.addSubview(self.blurView)
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "swipedDown:"))
        self.blurView.hidden = true
    }
    
    func resetDay() {
        
        for (index, dayPassed) in enumerate(allDaysPassed) {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if dateFormatter.stringFromDate(dayPassed.dateCompleted!) == dateFormatter.stringFromDate(self.currentDate) {
                var error: NSError?
                appDel.managedObjectContext!.deleteObject(dayPassed)
                appDel.managedObjectContext!.save(&error)
                appDel.managedObjectContext!.refreshObject(dayPassed, mergeChanges: true)
                self.allDaysPassed.removeAtIndex(index)
                self.calendarViewController?.daysCompleted = self.allDaysPassed
                self.calendarViewController?.datePickerView?.reloadData()
                if let err = error {
                    println(err)
                }
                self.turnRed()
                self.blurView.blurRadius = 0.0
                self.undoView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.blurView.hidden = true
                self.blurView.remove()
                appDel.managedObjectContext!.refreshObject(self.currentCourse!, mergeChanges: false)
                GoogleWearAlert.showAlert(title: "Day Reset", type: .Error)
                return
            }
        }
    }
    
    var counter = 0
    func swipedDown(gr: UIPanGestureRecognizer) {
        if dayCompleted {
            var vel = gr.velocityInView(self.view)
            self.blurView.refresh()
            
            if vel.y > 0 {
                if self.blurView.blurRadius < 10 {
                    self.blurView.hidden = false
                    self.blurView.blurRadius = self.blurView.blurRadius + 0.5
                }
            } else {
                self.blurView.blurRadius = self.blurView.blurRadius - 0.5
            }
            if gr.translationInView(self.view).y < 64 {
                self.undoView.transform = CGAffineTransformMakeTranslation(0, gr.translationInView(self.view).y)
            }
            
            if self.blurView.blurRadius <= 0 {
                self.blurView.blurRadius = 0
                self.blurView.hidden = true
                self.blurView.remove()
            }
            
            if gr.state == .Ended {
                if self.blurView.blurRadius >= 5.0 {
                    UIView.animateWithDuration(0.2, animations: {
                        self.blurView.blurRadius = 10.0
                        self.undoView.transform = CGAffineTransformMakeTranslation(0, 64)
                    })
                } else {
                    UIView.animateWithDuration(0.2, animations: {
                        self.blurView.blurRadius = 0.0
                        self.undoView.transform = CGAffineTransformMakeTranslation(0, 0)
                        self.blurView.hidden = true
                        self.blurView.remove()
                    })
                }
            }
        }
    }
    
    func appDidBecomeActive(app: UIApplication) {
        if let course = self.currentCourse {
            self.setColorForCurrentDate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calendarPressed(sender: UIButton) {
        self.blurView.blurRadius = 0.0
        self.undoView.transform = CGAffineTransformMakeTranslation(0, 0)
        self.blurView.hidden = true
        self.blurView.remove()
        self.checkAll = false
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
            self.calendarButton.transform = CGAffineTransformMakeTranslation(-self.view.frame.width, 0)
            self.checkAllButton.transform = CGAffineTransformMakeTranslation(-self.view.frame.width, 0)
            self.settingsButton.transform = CGAffineTransformMakeTranslation(-self.view.frame.width, 0)
            if self.dayCompleted {
                self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconCompletedHighlighted"), forState: .Normal)
                self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconCompleted"), forState: .Normal)
                self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconCompleted"), forState: .Normal)
            } else {
                self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconHighlighted"), forState: .Normal)
                self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIcon"), forState: .Normal)
                self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIcon"), forState: .Normal)
            }
        })
    }
    
    @IBAction func checkAllPressed(sender: UIButton) {
        self.blurView.blurRadius = 0.0
        self.undoView.transform = CGAffineTransformMakeTranslation(0, 0)
        self.blurView.hidden = true
        self.blurView.remove()
        if checkAll && !dayCompleted {
            var error: NSError?
            var checkedOff = NSEntityDescription.insertNewObjectForEntityForName("CompletionProgress", inManagedObjectContext: appDel.managedObjectContext!) as! CompletionProgress
            checkedOff.dateCompleted = currentDate
            appDel.managedObjectContext!.save(&error)
            
            allDaysPassed.append(checkedOff)
            currentCourse?.daysCompleted = NSSet(array: allDaysPassed)
            appDel.managedObjectContext!.save(&error)
            if let err = error {
                println(err)
            }
            
            self.calendarViewController?.daysCompleted = self.allDaysPassed
            self.turnGreen()
            GoogleWearAlert.showAlert(title: "Completed", type: .Success)
            self.calendarViewController!.daysCompleted = currentCourse!.daysCompleted.allObjects as! [CompletionProgress]
            self.calendarViewController!.datePickerView?.reloadData()
        }
        self.checkAll = true
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(0, 0)
            self.calendarButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.checkAllButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.settingsButton.transform = CGAffineTransformMakeTranslation(0, 0)
            if self.dayCompleted {
                self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconCompleted"), forState: .Normal)
                self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconCompletedHighlighted"), forState: .Normal)
                self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconCompleted"), forState: .Normal)
            } else {
                self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIcon"), forState: .Normal)
                self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconHighlighted"), forState: .Normal)
                self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIcon"), forState: .Normal)
            }
        })
    }
    
    @IBAction func settingsPressed(sender: UIButton) {
        self.blurView.blurRadius = 0.0
        self.undoView.transform = CGAffineTransformMakeTranslation(0, 0)
        self.blurView.hidden = true
        self.blurView.remove()
        self.checkAll = false
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.width, 0)
            self.calendarButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
            self.checkAllButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
            self.settingsButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
            if self.dayCompleted {
                self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconCompleted"), forState: .Normal)
                self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconCompleted"), forState: .Normal)
                self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconCompletedHighlighted"), forState: .Normal)
            } else {
                self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIcon"), forState: .Normal)
                self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIcon"), forState: .Normal)
                self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconHighlighted"), forState: .Normal)
            }
        })
        
    }
    
    @IBAction func backADayPressed(sender: UIBarButtonItem) {
        self.nextButton.enabled = true
        self.currentDate = self.currentDate.dateByAddingTimeInterval(-24*60*60)
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        self.navBar.topItem?.title = formatter.stringFromDate(currentDate)
        
        if self.currentCourse?.startDate.compare(self.currentDate) == .OrderedDescending {
            self.backButton.enabled = false
        }
        self.setColorForCurrentDate()
    }
    
    @IBAction func forwardADayPressed(sender: UIBarButtonItem) {
        self.backButton.enabled = true
        self.currentDate = self.currentDate.dateByAddingTimeInterval(24*60*60)
        var formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        self.navBar.topItem?.title = formatter.stringFromDate(currentDate)
        
        if NSCalendar.currentCalendar().isDateInToday(self.currentDate) {
            self.nextButton.enabled = false
        }
        self.setColorForCurrentDate()
    }
    
    func setColorForCurrentDate() {
        var totalTime = self.currentCourse!.startDate.timeIntervalSinceDate(self.currentCourse!.startDate.dateByAddingTimeInterval(90*24*60*60))
        var currentTime = self.currentCourse!.startDate.timeIntervalSinceDate(self.currentDate)
        progressView.value = Double((currentTime/totalTime)*90.0)
        progressView.setNeedsDisplay()
        
        self.daysLeftLabel.text = "\(90 - Int(round((currentTime/totalTime)*90.0)))"
        
        for dayPassed in allDaysPassed {
            appDel.managedObjectContext!.refreshObject(dayPassed, mergeChanges: true)
            
            if let day = dayPassed.dateCompleted {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if dateFormatter.stringFromDate(dayPassed.dateCompleted!) == dateFormatter.stringFromDate(self.currentDate) {
                    self.turnGreen()
                    return
                }
            }
        }
        self.turnRed()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectives.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = objectives[indexPath.row]
        return cell
    }
    
    func turnGreen() {
        dayCompleted = true
        if self.view.transform.tx < 0 {
            self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconCompleted"), forState: .Normal)
            self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconCompleted"), forState: .Normal)
            self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconCompletedHighlighted"), forState: .Normal)
        } else if self.view.transform.tx > 0 {
            self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconCompletedHighlighted"), forState: .Normal)
            self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconCompleted"), forState: .Normal)
            self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconCompleted"), forState: .Normal)
        } else {
            self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconCompleted"), forState: .Normal)
            self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconCompletedHighlighted"), forState: .Normal)
            self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconCompleted"), forState: .Normal)
        }
        
        self.daysLeftLabel.textColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.descriptionLabel.textColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.progressView.progressColor = 0x02D049
        self.progressView.setNeedsDisplay()
        
        self.navBar.barTintColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.settingsViewController?.navBar.barTintColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.calendarViewController?.navBar.barTintColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.backNavView.backgroundColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.settingsViewController?.backNavView.backgroundColor = UIColor.fromHex(0x02D049, alpha: 1.0)
        self.calendarViewController?.backNavView.backgroundColor = UIColor.fromHex(0x02D049, alpha: 1.0)
    }
    
    func turnRed() {
        dayCompleted = false
        if self.view.transform.tx < 0 {
            self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIcon"), forState: .Normal)
            self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIcon"), forState: .Normal)
            self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIconHighlighted"), forState: .Normal)
        } else if self.view.transform.tx > 0 {
            self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIconHighlighted"), forState: .Normal)
            self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIcon"), forState: .Normal)
            self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIcon"), forState: .Normal)
        } else {
            self.calendarButton.setBackgroundImage(UIImage(named: "CalendarIcon"), forState: .Normal)
            self.checkAllButton.setBackgroundImage(UIImage(named: "CheckIconHighlighted"), forState: .Normal)
            self.settingsButton.setBackgroundImage(UIImage(named: "SettingsIcon"), forState: .Normal)
        }
        
        self.daysLeftLabel.textColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.descriptionLabel.textColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.progressView.progressColor = 0xD02802
        self.progressView.setNeedsDisplay()
        
        self.navBar.barTintColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.settingsViewController?.navBar.barTintColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.calendarViewController?.navBar.barTintColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.backNavView.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.settingsViewController?.backNavView.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
        self.calendarViewController?.backNavView.backgroundColor = UIColor.fromHex(0xD02802, alpha: 1.0)
    }
    
}
