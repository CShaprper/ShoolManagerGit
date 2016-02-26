

import StoreKit
import UIKit

class PurchaseProductVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ISendProducts{
   private var _iap:StoreKitManager?
    private var _tableView = UITableView()
    private var _productsArray = Array<SKProduct>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _tableView.dataSource = self
        _tableView.delegate = self
        self._iap = StoreKitManager(presentingVC: self, alertOKOnlyDelegate: Alert_OK_Only(presentingView: self), alertGoSettingsDelegate: Alert_OK_GoToSettings(presentingView: self))
        self._iap?.setSendProductsDelegate(self)
    }

   /*MARK: TableView Delegates
    ###############################################################################################################*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _productsArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func sendProducts(productsArray: Array<SKProduct>) {
        self._productsArray = productsArray
    }
}
