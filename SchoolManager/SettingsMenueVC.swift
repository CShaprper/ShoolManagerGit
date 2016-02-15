

import UIKit
import iAd
import StoreKit

enum InfoMessages:String{
    case enabledDays = "enabledDays"
    case timeline = "timeline"
    case teachers = "teachers"
    case subjects = "subjects"
}

class SettingsMenueVC: UIViewController, UITabBarControllerDelegate, ADBannerViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    /*Outlets    ###############################################################################################################*/
    
    @IBOutlet var infoViewButton: UIButton!
    @IBOutlet var infoViewMessageTextView: UITextView!
    @IBOutlet var infoViewHeaderLabel: UILabel!
    @IBOutlet var infoViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet var BackgroundimageView: UIImageView!
    @IBOutlet var removeAdsButon: UIButton!
    @IBOutlet var rateNowButton: UIButton!
    var infomsg:String!
    var counter:Int = 0
    
    /*Members    ###############################################################################################################*/
    //Transition Object
    let transition = WipeTransition()
    var product_id: NSString?
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /*ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        product_id = "com.petersypek.SchoolManager"
        self.tabBarController!.delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDel.adDefaults.boolForKey("purchased"){
            loadAds()
            UIViewController.prepareInterstitialAds()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*Unhide Toolbar from Navigation Controller*/
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.infoViewCenterConstraint.constant = -800
        self.navigationController?.setToolbarHidden(true, animated: animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        removeAdsButon.setImage(UIImage(named: "RemoveAds".localized), forState: .Normal)
        rateNowButton.setImage(UIImage(named: "RateNow".localized), forState: .Normal)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showInfoMessage()
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    /*MARK: Advertising    ###############################################################################################################*/
    func loadAds(){
        self.appDel.adBannerView.removeFromSuperview()
        self.appDel.adBannerView.delegate = nil
        self.appDel.adBannerView = ADBannerView(frame: CGRect.zero)
        
        //ADBanner at the screen Bottom
        self.appDel.adBannerView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - self.appDel.adBannerView.frame.size.height / 2 - 50)
        
        self.appDel.adBannerView.delegate = self
        self.appDel.adBannerView.hidden = true
        view.addSubview(self.appDel.adBannerView)
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.appDel.adBannerView.hidden = true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDel.adBannerView.hidden = false
    }
    
    /*MARK: InApp Purchase    ###############################################################################################################*/
    @IBAction func removeAdsButtunAction(sender: AnyObject) {
        buyConsumable()
    }
    
    func buyConsumable(){
        print("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: self.product_id!);
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
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if !appDel.adDefaults.boolForKey("purchased"){
            counter++
            if counter == 2{
                counter = 0
                let destination = segue.destinationViewController as UIViewController
                destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic
            }
        }
        if let dest = segue.destinationViewController as? EnabledDaysSettingsVC{
            dest.transitioningDelegate = transition
        }
        if let dest = segue.destinationViewController as? TeacherTableVC{
            dest.transitioningDelegate = transition
        }
        if let dest = segue.destinationViewController as? TimelineVC{
            dest.transitioningDelegate = transition
        }
        if let dest = segue.destinationViewController as? SubjectsVC{
            dest.transitioningDelegate = transition
        }
    }
    
    @IBAction func unwindToSettings(segue:UIStoryboardSegue){
    }
    
    @IBAction func rateMeButtonAction() {
        UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.comrate/app/school-manager/id1071047172")!);
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    private func showInfoMessage(){
        let result = Day.FetchData(appDel.managedObjectContext)
        let res = HoursPerDayData.FetchData(appDel.managedObjectContext)
        var returnvalue = (result!.count == 0 || res!.count == 0) ? true : false
        if returnvalue{
            configureInfoView(InfoMessages.enabledDays.rawValue)
            return
        }
        
        let result2 = TimelineData.FetchData(appDel.managedObjectContext)
        returnvalue = result2!.count == 0 ? true : false
        if returnvalue{
            configureInfoView(InfoMessages.timeline.rawValue)
            return
        }
        
        let result3 = Teacher.FetchData(appDel.managedObjectContext)
        returnvalue = result3!.count == 0 ? true : false
        if returnvalue{
            configureInfoView(InfoMessages.teachers.rawValue)
            return
        }
        
        let result4 = Subject.FetchData(appDel.managedObjectContext)
        returnvalue = result4!.count == 0 ? true : false
        if returnvalue{
            configureInfoView(InfoMessages.subjects.rawValue)
            return
        }
        configureInfoView("none")
    }
    private func configureInfoView(infoViewMessage:String){
        switch infoViewMessage{
        case InfoMessages.enabledDays.rawValue:
            infoViewHeaderLabel.text = "EnabledDaysInfoHeader".localized
            infoViewMessageTextView.text = "EnabledDaysInfoMessage".localized
            infoViewButton.setImage(UIImage(named: "SettingsButton"), forState: .Normal)
            infomsg = infoViewMessage
            unhideInfoMessageView()
            break
        case InfoMessages.timeline.rawValue:
            infoViewHeaderLabel.text = "TimelineInfoHeader".localized
            infoViewMessageTextView.text = "TimelineInfoMessage".localized
            infoViewButton.setImage(UIImage(named: "TimelineButton"), forState: .Normal)
            infomsg = infoViewMessage
            unhideInfoMessageView()
            break
        case InfoMessages.teachers.rawValue:
            infoViewHeaderLabel.text = "TeacherInfoHeader".localized
            infoViewMessageTextView.text = "TeacherInfoMessage".localized
            infoViewButton.setImage(UIImage(named: "TeacherButton"), forState: .Normal)
            infomsg = infoViewMessage
            unhideInfoMessageView()
            break
        case InfoMessages.subjects.rawValue:
            infoViewHeaderLabel.text = "SubjectsInfoHeader".localized
            infoViewMessageTextView.text = "SubjectsInfoMessage".localized
            infoViewButton.setImage(UIImage(named: "SubjectButton"), forState: .Normal)
            infomsg = infoViewMessage
            unhideInfoMessageView()
            break
        default:
            infomsg = infoViewMessage
            break
        }
    }
    
    private func unhideInfoMessageView(){
        UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.infoViewCenterConstraint.constant += 800
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func infoViewButtonAction() {
        switch infomsg{
        case InfoMessages.enabledDays.rawValue:
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.infoViewCenterConstraint.constant -= 800
                self.view.layoutIfNeeded()
                }, completion: { (hideWelcomeMessageAction) -> Void in self.performSegueWithIdentifier("ShowEnabledDays", sender: nil) })
            break
        case InfoMessages.timeline.rawValue:
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.infoViewCenterConstraint.constant -= 800
                self.view.layoutIfNeeded()
                }, completion: { (hideWelcomeMessageAction) -> Void in self.performSegueWithIdentifier("ShowTimeline", sender: nil)})
            break
        case InfoMessages.teachers.rawValue:
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.infoViewCenterConstraint.constant -= 800
                self.view.layoutIfNeeded()
                }, completion: { (hideWelcomeMessageAction) -> Void in self.performSegueWithIdentifier("ShowTeachersSegue", sender: nil) })
            break
        case InfoMessages.subjects.rawValue:
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.infoViewCenterConstraint.constant -= 800
                self.view.layoutIfNeeded()
                }, completion: { (hideWelcomeMessageAction) -> Void in self.performSegueWithIdentifier("ShowNewSubject", sender: nil) })
            break
        default:
            break
        }
        
    }
}
