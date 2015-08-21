//
//  Journal+Extension.swift
//  90 Day
//
//  Created by Micah Wilson on 8/20/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit
import CoreData

extension Journal {
    
    class func addJournal(entry: String, entryDate: NSDate, campaign: Course, context: NSManagedObjectContext, error: NSErrorPointer) -> Journal {
        let newJournal = NSEntityDescription.insertNewObjectForEntityForName("Journal", inManagedObjectContext: context) as! Journal
        newJournal.entry = entry
        newJournal.entryDate = entryDate
        
        var allJournals = campaign.journals.allObjects as! [Journal]
        allJournals.append(newJournal)
        campaign.journals = NSSet(array: allJournals)
        
        context.save(error)
        if let err = error.memory {
            println(err)
        }
        return newJournal
    }
}
