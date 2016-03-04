//
//  StoreKitManager.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = self.priceLocale
        return formatter.stringFromNumber(self.price)!
    }    
}

class StoreKitManager:NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private let _productIdentifiers:Set<String>!
    private var _product: SKProduct?
    private var _productsArray = Array<SKProduct>()
    private let _presentingVC:UIViewController?
    private let _appDel:AppDelegate?
    private let _alertOKOnlyDelegate:IAlert?
    private let _alertGoSettingdDelegate:IAlert_OneAction?
    private var _sendProducstDelegate:ISendProducts?
    private let _activityIndicator:IAnimation?
    private let _removeAdIdentifier:String!
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
        self._removeAdIdentifier = _appDel?.removeAdsIdentifier 
        self._productIdentifiers = Set([_removeAdIdentifier])
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
    func restorePurchases(){
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    @objc func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self._activityIndicator?.beginAnimation()
            print("Products request")
            let products = response.products
            for product in products{
                print(product.productIdentifier)
                print(product.description)
                print(product.priceLocale)
                print(product.localizedTitle)
                print(product.localizedDescription)
                print(product.price)
                self._productsArray.append(product)
            }
            self._sendProducstDelegate?.sendProducts(self._productsArray)
            self._activityIndicator?.endAnimation()
        })
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
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("Transactions Restored")
            for transaction in queue.transactions {
                let t: SKPaymentTransaction = transaction
                
                let prodID = t.payment.productIdentifier as String
                
                switch prodID {
                case self._removeAdIdentifier:
                    print("remove ads")
                    self._appDel?.userDefaults.setBool(true, forKey: prodID)
                default:
                    print("IAP not setup")
                }
                self._alertOKOnlyDelegate?.showAlert("RestorePurchasesHeader".localized, message: "RestorePurchasesMessage".localized)
            }
        }
    }
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: self._productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._alertGoSettingdDelegate?.showAlert_OneAction("IAppNotEnabledHeader".localized, message: "IAppNotEnabledMessage".localized, actionTitle: "IAppNotEnabledActionHeader".localized)
            })
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        if transaction.payment.productIdentifier == self._removeAdIdentifier
        {
            print("Non-Consumable Product Remove Ads Purchased")
            self._appDel?.userDefaults.setBool(true, forKey: transaction.payment.productIdentifier)
        }
        else if transaction.payment.productIdentifier == "com"
        {
            print("Auto-Renewable Subscription Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com"
        {
            print("Free Subscription Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com"
        {
            print("Non-Renewing Subscription Product Purchased")
            // Unlock Feature
        }
    }
    
}