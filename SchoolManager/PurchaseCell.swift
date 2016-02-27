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
    private var _ProductDescription:String?
    private var _ProductHeader:String?
    
    func configureCell(product:SKProduct){
        if product.productIdentifier == "com.petersypek.SchoolManager"{
            self._ProductDescription  =  "RemoveAdsDesription"
            self._ProductHeader = "RemoveAdsHeader"
        }
        self.productDescription.text! = _ProductDescription!.localized
        self.productTitle.text! = _ProductHeader!.localized
        self.productPrice.text! = String(product.localizedPrice())
        self.productPrice.layer.cornerRadius  = 5
    }
}
