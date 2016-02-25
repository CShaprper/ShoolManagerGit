//
//  IAlert.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation

protocol IAlert: class{
    func showAlert(title:String, message:String)
}