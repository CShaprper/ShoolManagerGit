//
//  StringExtensions.swift
//  SchoolManager
//
//  Created by Peter Sypek on 02.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
