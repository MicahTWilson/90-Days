//
//  CompletionProgress.swift
//  90 Day
//
//  Created by Micah Wilson on 5/24/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import Foundation
import CoreData
@objc(CompletionProgress)
class CompletionProgress: NSManagedObject {

    @NSManaged var dateCompleted: NSDate?

}
