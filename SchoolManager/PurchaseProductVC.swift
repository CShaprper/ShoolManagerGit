

import StoreKit
import UIKit

class PurchaseProductVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ISendProducts{
    private var _iap:StoreKitManager?
    private var _productsArray = Array<SKProduct>()
    private var _activityIndicatorAnimation:IAnimation?
    private var _selectedProduct:SKProduct?
    
    @IBOutlet var tableview: UITableView!
    
    /*MARK: ViewController Life Cycle    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        self._activityIndicatorAnimation = ActivityIndicatorAnimation(presentingView: self)
        self._iap = StoreKitManager(presentingVC: self, alertOKOnlyDelegate: Alert_OK_Only(presentingView: self), alertGoSettingsDelegate: Alert_OK_GoToSettings(presentingView: self), activityIndicatorAnimation: self._activityIndicatorAnimation!)
        self._activityIndicatorAnimation?.beginAnimation()
        self._iap?.setSendProductsDelegate(self)
        self._iap?.requestProductData()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
        _ = tableview.indexPathForSelectedRow
        self._selectedProduct = self._productsArray[indexPath.row]
        self._iap?.buyProduct(_selectedProduct!)
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
        self._iap!.restorePurchases()   
    }
}
