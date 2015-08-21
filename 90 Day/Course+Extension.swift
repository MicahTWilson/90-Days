//
//  Course+Extension.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import CoreData

extension Course {
    class func addNewCourse(length: Int, startDate: NSDate, goals: [String], context: NSManagedObjectContext, error: NSErrorPointer) -> Course {
        
        let newCourse = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: context) as! Course
        newCourse.length = length
        newCourse.startDate = NSCalendar.currentCalendar().dateFromComponents(NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay, fromDate: startDate))!
        
        var goalChallenges = [Challenge]()
        for goal in goals {
            goalChallenges.append(Challenge.addChallenge(goal, context: context, error: error))
        }
        newCourse.challenges = NSSet(array: goalChallenges)
        
        context.save(error)
        return newCourse
    }
    
    var goals : [Challenge] {
        let allGoals = self.challenges.allObjects as NSArray
        let sortedArray = allGoals.sortedArrayUsingDescriptors([NSSortDescriptor(key: "creationDate", ascending: true)]) as! [Challenge]
        
        return sortedArray
    }
}