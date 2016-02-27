//
//  StoreKitManager.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitManager:NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private let _productIdentifiers = Set(["com.petersypek.SchoolManager"])
    private var _product: SKProduct?
    private var _productsArray = Array<SKProduct>()
    private let _presentingVC:UIViewController?
    private let _appDel:AppDelegate?
    private let _alertOKOnlyDelegate:IAlert?
    private let _alertGoSettingdDelegate:IAlert_OneAction?
    private var _sendProducstDelegate:ISendProducts?
    private let _activityIndicator:IAnimation?
    
    /**
     **Constructor**
     
     - parameter presentingViewController: - UIViewController: *The ViewController from caller of this class*
     */
    init(presentingVC:UIViewController, alertOKOnlyDelegate:IAlert, alertGoSettingsDelegate:IAlert_OneAction, activityIndicatorAnimation:IAnimation){
        self._alertOKOnlyDelegate  = alertOKOnlyDelegate
        self._alertGoSettingdDelegate = alertGoSettingsDelegate
        self._presentingVC = presentingVC
        self._appDel = UIApplication.sharedApplication().delegate as? AppDelegate
        self._activityIndicator = activityIndicatorAnimation
    }
    
    func setSendProductsDelegate(delegate:ISendProducts){
        self._sendProducstDelegate  = delegate
    }
    
    /*MARK: StoreKit Helpers    ###############################################################################################################*/
    func buyProduct(product:SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    
    @objc func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self._activityIndicator?.beginAnimation()
        print("Products request")
        let products = response.products
        for product in products{
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            self._productsArray.append(product)
        }
        self._sendProducstDelegate?.sendProducts(self._productsArray)
        self._activityIndicator?.endAnimation() 
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                self._appDel?.userDefaults.setBool(false, forKey: transaction.payment.productIdentifier)
            default:
                break
            }
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("Transactions Restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.petersypek.SchoolManager":
                print("remove ads")
                self._appDel?.userDefaults.setBool(true, forKey: prodID)
            default:
                print("IAP not setup")
            }
            self._alertOKOnlyDelegate?.showAlert("Thank You", message: "Your purchase(s) were restored.")
        }
    }
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set(["com.petersypek.SchoolManager"]))
            request.delegate = self
            request.start()
        } else {
            self._alertGoSettingdDelegate?.showAlert_OneAction("In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", actionTitle: "Go to Settings")
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        if transaction.payment.productIdentifier == "com.petersypek.SchoolManager"
        {
            print("Non-Consumable Product Remove Ads Purchased")
            self._appDel?.userDefaults.setBool(true, forKey: transaction.payment.productIdentifier)
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap3"
        {
            print("Auto-Renewable Subscription Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap4"
        {
            print("Free Subscription Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.brianjcoleman.testiap5"
        {
            print("Non-Renewing Subscription Product Purchased")
            // Unlock Feature
        }
    }
    
}