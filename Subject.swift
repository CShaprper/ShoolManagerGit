//
//  Subject.swift
//  SchoolManager
//
//  Created by Peter Sypek on 21.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import CoreData


class Subject: NSManagedObject {
    
    static let EntityName = "Subject"    
    @NSManaged var name : String?
    
    static let Key_id = "id"
    @NSManaged var keyid : String?

}
