//
//  ProtocolClasses.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation

protocol IInAppPurchase: class{
    func requestProductData()
    
    func productsRequest()
    
    func purchaseProduct(product:NSString)
}