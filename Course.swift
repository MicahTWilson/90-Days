//
//  Couse.swift
//  90 Day
//
//  Created by Micah Wilson on 5/24/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import CoreData
@objc(Course)
class Course: NSManagedObject {

    @NSManaged var startDate: NSDate
    @NSManaged var challenges: NSSet
    @NSManaged var daysCompleted: NSSet

}
