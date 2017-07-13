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
        let formatter = NumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
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
        self._appDel = UIApplication.shared.delegate as? AppDelegate
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
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    func restorePurchases(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @objc func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async(execute: { () -> Void in
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
            self._sendProducstDelegate?.sendProducts(productsArray: self._productsArray)
            self._activityIndicator?.endAnimation()
        })
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                self._appDel?.userDefaults.set(false, forKey: transaction.payment.productIdentifier)
            default:
                break
            }
        }
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        DispatchQueue.main.async() { () -> Void in
            print("Transactions Restored")
            for transaction in queue.transactions {
                let t: SKPaymentTransaction = transaction
                
                let prodID = t.payment.productIdentifier as String
                
                switch prodID {
                case self._removeAdIdentifier:
                    print("remove ads")
                    self._appDel?.userDefaults.set(true, forKey: prodID)
                default:
                    print("IAP not setup")
                }
                self._alertOKOnlyDelegate?.showAlert(title: "RestorePurchasesHeader".localized, message: "RestorePurchasesMessage".localized)
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
            DispatchQueue.main.async(execute: { () -> Void in
                self._alertGoSettingdDelegate?.showAlert_OneAction(title: "IAppNotEnabledHeader".localized, message: "IAppNotEnabledMessage".localized, actionTitle: "IAppNotEnabledActionHeader".localized)
            })
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        if transaction.payment.productIdentifier == self._removeAdIdentifier
        {
            print("Non-Consumable Product Remove Ads Purchased")
            self._appDel?.userDefaults.set(true, forKey: transaction.payment.productIdentifier)
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
