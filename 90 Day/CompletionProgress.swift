//
//  CompletionProgress.swift
//  
//
//  Created by Micah Wilson on 8/19/15.
//
//

import Foundation
import CoreData
@objc(CompletionProgress)
class CompletionProgress: NSManagedObject {

    @NSManaged var dateCompleted: NSDate?
    @NSManaged var percentCompleted: NSNumber
    @NSManaged var campaign: Course

}
