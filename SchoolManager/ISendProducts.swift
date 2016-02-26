//
//  ISendProducts.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation
import StoreKit

protocol ISendProducts: class{
    func sendProducts(productsArray:Array<SKProduct>)
}