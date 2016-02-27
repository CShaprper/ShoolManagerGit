

import StoreKit
import UIKit

class PurchaseProductVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ISendProducts{
    private var _iap:StoreKitManager?
    private var _productsArray = Array<SKProduct>()
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        self._iap = StoreKitManager(presentingVC: self, alertOKOnlyDelegate: Alert_OK_Only(presentingView: self), alertGoSettingsDelegate: Alert_OK_GoToSettings(presentingView: self), activityIndicatorAnimation: ActivityIndicatorAnimation(presentingView: self))
        self._iap?.setSendProductsDelegate(self)
        self._iap?.requestProductData()
    }
    
    /*MARK: TableView Delegates
    ###############################################################################################################*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PurchaseCell") as? PurchaseCell{
            cell.configureCell(self._productsArray[indexPath.row])
            return cell
        }
        else{
            return PurchaseCell()
        }
        
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
        self.tableview.reloadData()
        self.tableview.AnimateTable()
    }
    @IBAction func restorePurchasesButton() {
        self._iap.requestProductData()
    }
}
