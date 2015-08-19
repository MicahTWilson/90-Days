//
//  CalendarViewController.swift
//  90 Day
//
//  Created by Micah Wilson on 5/23/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController, RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var backNavView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    var datePickerView: RSDFDatePickerView?
    var course: Course?
    var daysCompleted = [CompletionProgress]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerView = RSDFDatePickerView(frame: backgroundView.frame)
        datePickerView!.delegate = self
        datePickerView!.dataSource = self
        self.view.addSubview(datePickerView!)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldHighlightDate date: NSDate!) -> Bool {
        return true
    }
    
    func datePickerView(view: RSDFDatePickerView!, shouldMarkDate date: NSDate!) -> Bool {
        if let currentCourse = course {
            var startDate = currentCourse.startDate.dateByAddingTimeInterval(-24*60*60)
            var endDate = startDate.dateByAddingTimeInterval(90*24*60*60)
            return isDateInRange(date, startDate: startDate, endDate: endDate)
        } else {
            return false
        }
    }
    
    func datePickerView(view: RSDFDatePickerView!, isCompletedAllTasksOnDate date: NSDate!) -> Bool {
        for day in daysCompleted {
            if self.isDateInRange(day.dateCompleted!, startDate: date, endDate: date.dateByAddingTimeInterval(24*60*60)) {
                return true
            }
        }
        return false
    }
    
    func isDateInRange(date: NSDate, startDate: NSDate, endDate: NSDate) -> Bool {
        return date.compare(startDate) == .OrderedDescending && date.compare(endDate) == .OrderedAscending
    }
}