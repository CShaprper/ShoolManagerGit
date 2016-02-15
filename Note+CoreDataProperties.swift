//
//  Note+CoreDataProperties.swift
//  SchoolManager
//
//  Created by Peter Sypek on 15.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var guid: String?
    @NSManaged var note: String?
    @NSManaged var reminderDate: NSDate?
    @NSManaged var subject: Subject?
    @NSManaged var user: User?

}
