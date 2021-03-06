//
//  TimelineData+CoreDataProperties.swift
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

extension TimelineData {

    @NSManaged var endTime: Date?
    @NSManaged var hour: NSNumber?
    @NSManaged var startTime: Date?
    @NSManaged var user: User?

}
