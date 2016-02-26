//
//  PurchaseCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseCell: UITableViewCell {

    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDescription: UILabel!
    @IBOutlet var productPrice: UILabel!
    
    func configureCell(product:SKProduct){
        self.productDescription.text! = product.description
        self.productTitle.text! = product.localizedDescription
        self.productPrice.text! = String(product.price)
    }
}
