//
//  Course.swift
//  
//
//  Created by Micah Wilson on 8/19/15.
//
//

import Foundation
import CoreData
@objc(Course)
class Course: NSManagedObject {

    @NSManaged var length: NSNumber
    @NSManaged var startDate: NSDate
    @NSManaged var challenges: NSSet
    @NSManaged var daysCompleted: NSSet

}
