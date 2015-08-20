//
//  Challenge.swift
//  
//
//  Created by Micah Wilson on 8/19/15.
//
//

import Foundation
import CoreData
@objc(Challenge)
class Challenge: NSManagedObject {

    @NSManaged var creationDate: NSDate
    @NSManaged var task: String
    @NSManaged var daysCompleted: NSSet

}
