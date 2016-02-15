//
//  Planer+CoreDataProperties.swift
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

extension Planer {

    @NSManaged var daystring: String?
    @NSManaged var isEmptyElement: NSNumber?
    @NSManaged var isHeaderElement: NSNumber?
    @NSManaged var room: String?
    @NSManaged var selectedWeek: NSNumber?
    @NSManaged var day: Day?
    @NSManaged var hour: TimelineData?
    @NSManaged var subject: Subject?
    @NSManaged var teacher: Teacher?
    @NSManaged var user: User?

}
