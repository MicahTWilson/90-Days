//
//  Journal.swift
//  
//
//  Created by Micah Wilson on 8/20/15.
//
//

import Foundation
import CoreData
@objc(Journal)
class Journal: NSManagedObject {

    @NSManaged var entry: String
    @NSManaged var entryDate: NSDate

}
