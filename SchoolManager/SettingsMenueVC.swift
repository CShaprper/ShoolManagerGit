

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
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /*ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        buyConsumable()
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
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1071047172")!)
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
