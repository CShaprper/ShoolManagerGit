//
//  Subject+CoreDataProperties.swift
//  SchoolManager
//
//  Created by Peter Sypek on 21.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Subject {

    @NSManaged var subject: String?
    @NSManaged var id: String?
    @NSManaged var day: Day?

}
