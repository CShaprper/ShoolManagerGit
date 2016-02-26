//
//  IAlert_OneAction.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation

protocol IAlert_OneAction: class{
     func showAlert_OneAction(title:String, message:String, actionTitle:String)
}