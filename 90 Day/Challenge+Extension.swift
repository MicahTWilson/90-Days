//
//  Challenge+Extension.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import CoreData

extension Challenge {

    class func addChallenge(goal: String, context: NSManagedObjectContext, error: NSErrorPointer) -> Challenge {
        let newChallenge = NSEntityDescription.insertNewObjectForEntityForName("Challenge", inManagedObjectContext: context) as! Challenge
        newChallenge.creationDate = NSDate()
        newChallenge.task = goal
        context.save(error)
        
        return newChallenge
    }
    
}