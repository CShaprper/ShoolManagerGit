//
//  InAppPurchaseManager.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchaseManager:IInAppPurchase, IAlert{
    private var _productIdentifiers: Set<NSObject>?
    private vor _storeKitDelegate:
    
    init(productIdentifiers:Set<NSObject>){
        //"com.petersypek.SchoolManager"
        self._productIdentifiers = productIdentifiers
    }
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self._productIdentifiers! as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            var alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    func buyConsumable(){
        print("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: self._product_id!);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fething Products");
        }else{
            print("can't make purchases");
        }
    }
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    // Delegate Methods for IAP
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("got the request from Apple")
        let count : Int = response.products.count
        if (count>0) {
            _ = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                let alert = UIAlertController(title: validProduct.localizedTitle, message: validProduct.localizedDescription, preferredStyle: .Alert)
                let formatter = NSNumberFormatter()
                formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                formatter.locale = NSLocale.currentLocale()
                alert.addAction(UIAlertAction(title: String(formatter.stringFromNumber(validProduct.price)!), style: .Default, handler: { (UIAlertAction) -> Void in self.buyProduct(validProduct); }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Alert_Action_Cancel", comment: "-"), style: .Default, handler: { (UIAlertAction) -> Void in  }))
                presentViewController(alert, animated: true, completion: nil)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    func request(request: SKRequest, didFailWithError error: NSError) {
        let alert = UIAlertController(title: NSLocalizedString("Alert_Error_Title", comment: "-"), message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in  }))
        presentViewController(alert, animated: true, completion: nil)
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    print("Product Purchased");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    appDel.adDefaults.setBool(true , forKey: "purchased")
                    break;
                case .Failed:
                    print("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    appDel.adDefaults.setBool(false , forKey: "purchased")
                    break;
                case .Restored:
                    print("Already Purchased");
                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                    appDel.adDefaults.setBool(true , forKey: "purchased")
                default:
                    break;
                }
            }
        }
        
    }
    
}