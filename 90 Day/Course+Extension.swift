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
        newCourse.startDate = startDate
        
        var goalChallenges = [Challenge]()
        for goal in goals {
            goalChallenges.append(Challenge.addChallenge(goal, context: context, error: error))
        }
        newCourse.challenges = NSSet(array: goalChallenges)
        
        context.save(error)
        return newCourse
    }
}