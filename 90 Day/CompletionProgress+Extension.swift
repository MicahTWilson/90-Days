//
//  CompletionProgress+Extension.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit
import CoreData

extension CompletionProgress {
    class func addCompletionProgress(date: NSDate, context: NSManagedObjectContext, error: NSErrorPointer) -> CompletionProgress {
        let progress = NSEntityDescription.insertNewObjectForEntityForName("CompletionProgress", inManagedObjectContext: context) as! CompletionProgress
        progress.dateCompleted = date
        context.save(error)
        if let err = error.memory {
            println(err)
        }
        return progress
    }
}
