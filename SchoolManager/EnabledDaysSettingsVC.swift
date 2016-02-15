
import UIKit
import CoreData
import iAd


class EnabledDaysSettingsVC: UIViewController, ADBannerViewDelegate {
    /*@IBOutlet & Menbers
    ###############################################################################################################*/
    @IBOutlet var lbl_MondaySwitch: UILabel!
    @IBOutlet var lbl_TuesdaySwitch: UILabel!
    @IBOutlet var lbl_WensdaySwitch: UILabel!
    @IBOutlet var lbl_ThursdaySwitch: UILabel!
    @IBOutlet var lbl_FridaySwitch: UILabel!
    @IBOutlet var lbl_SaturdaySwitch: UILabel!
    @IBOutlet var switchMonday: UISwitch!
    @IBOutlet var switchTuesday: UISwitch!
    @IBOutlet var switchWensday: UISwitch!
    @IBOutlet var switchThursday: UISwitch!
    @IBOutlet var switchFriday: UISwitch!
    @IBOutlet var switchSaturday: UISwitch!
    
    @IBOutlet var BackgroundImageView: UIImageView!
    @IBOutlet var hoursPerDaySlider: UISlider!
    @IBOutlet var lblHoursPerDay: UILabel!
    /*Members
    ###############################################################################################################*/
    let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
    //TimelIne Instance
    var timeline = TimelineManager()
    var layers:[CALayer] = [CALayer]()
    
    /*ViewController Delegates
    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.adDefaults.boolForKey("purchased"){
            loadAds()
        }
        self.layers.append(switchMonday.layer)
        self.layers.append(switchTuesday.layer)
        self.layers.append(switchWensday.layer)
        self.layers.append(switchThursday.layer)
        self.layers.append(switchFriday.layer)
        self.layers.append(switchSaturday.layer)
        UIDesignHelper.ShadowMakerMultipleLayers(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(10), layers: layers)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide Toolbar
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
        // Sets the State of UISwitches corresponding to saved values
        SetSwitchStateCorrespondingToSavedValues()
        let hours = TimelineData.FetchData(appDel.managedObjectContext)
        if hours!.count == 0{
            lblHoursPerDay.text = "1"
        }else{
            lblHoursPerDay.text = String(hours!.count)
            hoursPerDaySlider.value = NSString(string: String(hours!.count)).floatValue
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func shouldAutorotate() -> Bool {
        return true
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
        self.appDel.adBannerView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - self.appDel.adBannerView.frame.size.height / 2)
        
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
    
    /*Prepare For Segue    ##############################################################################################################*/
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var toViewController: UIViewController!
    switch segue.identifier!{
    case "unwindToSettingsFromDays":
    toViewController = segue.destinationViewController  as! SettingsMenueVC
    // instead of using the default transition animation, we'll ask
    // the segue to use our custom TransitionManager object to manage the transition animation
    toViewController.transitioningDelegate = self.backtransition
    break
    default:
    break
    }
    }*/
    
    
    /*  @IBActions
    ###############################################################################################################*/
    var isFirstTouch:Bool = false
    @IBAction func HoursPerDaySliderChanged(sender: UISlider) {
        let hdp:[HoursPerDayData] = HoursPerDayData.FetchData(appDel.managedObjectContext)!
        let hours = TimelineData.FetchData(appDel.managedObjectContext)!
        let hr = Int(sender.value)
        if  hr  <= hours.count{
            if isFirstTouch{
                hoursPerDaySlider.value = NSNumber(integer: hours.count).floatValue
                lblHoursPerDay.text = NSNumber(integer: hours.count).stringValue
                let alert = UIAlertController(title: NSLocalizedString("EnabledDaysVC_AlertHourDeleteDisabled_Title", comment: "-"), message: "\(NSLocalizedString("EnabledDaysVC_AlertHourDeleteDisabled_MessagePaart1", comment: "-")) \(hr) \(NSLocalizedString("EnabledDaysVC_AlertHourDeleteDisabled_MessagePaart2", comment: "-"))", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                isFirstTouch = false
                let h:HoursPerDayData = hdp[0]
                h.hoursCount = String(hours.count)
            }
        }else{
            isFirstTouch = true
            lblHoursPerDay.text = NSNumber(integer: hr).stringValue
            if hdp.count == 0{
                HoursPerDayData.SaveHoursPerDayCount(String(hr), context: appDel.managedObjectContext)
            }else{
                let h:HoursPerDayData = hdp[0]
                h.hoursCount = String(hr)
            }
        }
        appDel.saveContext()
    }
    @IBAction func switchMondayAction(sender: AnyObject) {
        if switchMonday.on {
            print("\(lbl_MondaySwitch.text!) is on")
            Day.SaveDay(lbl_MondaySwitch.text!, intSortnumber: NSNumber(integer: 2), context: appDel.managedObjectContext)
        }
        else{
            if Planer.checkIfDayContaisPlanerElements(lbl_MondaySwitch.text!, context: appDel.managedObjectContext){
                switchMonday.on = true
                createDisabledDayDeleteAlert()
            }else{
                print("\(lbl_MondaySwitch.text!) is off")
                Day.DeleteDayWithPredicate(lbl_MondaySwitch.text!, context: appDel.managedObjectContext)
            }
        }
    }
    @IBAction func switchTuesdayAction(sender: AnyObject) {
        if switchTuesday.on {
            print("\(lbl_TuesdaySwitch.text!) is on")
            Day.SaveDay(lbl_TuesdaySwitch.text!, intSortnumber: NSNumber(integer: 3), context:  appDel.managedObjectContext)
        }
        else{
            if Planer.checkIfDayContaisPlanerElements(lbl_TuesdaySwitch.text!, context: appDel.managedObjectContext){
                switchTuesday.on = true
                createDisabledDayDeleteAlert()
            }else{
                print("\(lbl_TuesdaySwitch.text!) is off")
                Day.DeleteDayWithPredicate(lbl_TuesdaySwitch.text!, context: appDel.managedObjectContext)
            }
        }
    }
    @IBAction func switchWensdayAction(sender: AnyObject) {
        if switchWensday.on {
            print("\(lbl_WensdaySwitch.text!) is on")
            Day.SaveDay(lbl_WensdaySwitch.text!, intSortnumber: NSNumber(integer: 4), context: appDel.managedObjectContext)
        }
        else{
            if Planer.checkIfDayContaisPlanerElements(lbl_WensdaySwitch.text!, context: appDel.managedObjectContext){
                switchWensday.on = true
                createDisabledDayDeleteAlert()
            }else{
                print("\(lbl_WensdaySwitch.text!) is off")
                Day.DeleteDayWithPredicate(lbl_WensdaySwitch.text!, context: appDel.managedObjectContext)
            }
        }
    }
    @IBAction func switchThursdayAction(sender: AnyObject) {
        if switchThursday.on {
            print("\(lbl_ThursdaySwitch.text!) is on")
            Day.SaveDay(lbl_ThursdaySwitch.text!, intSortnumber: NSNumber(integer: 5), context:  appDel.managedObjectContext)
        }
        else{
            if Planer.checkIfDayContaisPlanerElements(lbl_ThursdaySwitch.text!, context: appDel.managedObjectContext){
                switchThursday.on = true
                createDisabledDayDeleteAlert()
            }else{
                print("\(lbl_ThursdaySwitch.text!) is off")
                Day.DeleteDayWithPredicate(lbl_ThursdaySwitch.text!, context: appDel.managedObjectContext)
            }
        }
    }
    @IBAction func switchFridayAction(sender: AnyObject) {
        if switchFriday.on {
            print("\(lbl_FridaySwitch.text!) is on")
            Day.SaveDay(lbl_FridaySwitch.text!, intSortnumber: NSNumber(integer: 6), context:  appDel.managedObjectContext)
        }
        else{
            if Planer.checkIfDayContaisPlanerElements(lbl_FridaySwitch.text!, context: appDel.managedObjectContext){
                switchFriday.on = true
                createDisabledDayDeleteAlert()
            }else{
                print("\(lbl_FridaySwitch.text!) is off")
                Day.DeleteDayWithPredicate(lbl_FridaySwitch.text!, context: appDel.managedObjectContext)
            }
        }
    }
    @IBAction func switchSaturdayAction(sender: AnyObject) {
        if switchSaturday.on {
            print("\(lbl_SaturdaySwitch.text!) is on")
            Day.SaveDay(lbl_SaturdaySwitch.text!, intSortnumber: NSNumber(integer: 7), context:  appDel.managedObjectContext)
        }
        else{
            if Planer.checkIfDayContaisPlanerElements(lbl_SaturdaySwitch.text!, context: appDel.managedObjectContext){
                switchSaturday.on = true
                createDisabledDayDeleteAlert()
            }else{
                print("\(lbl_SaturdaySwitch.text!) is off")
                Day.DeleteDayWithPredicate(lbl_SaturdaySwitch.text!, context: appDel.managedObjectContext)
            }
        }
    }
    
    /*MARK:  ViewController Helper functions
    ###############################################################################################################*/
    /**Sets the initial state of the Enabled Days switches
    corresponding to saved days in core data*/
    private func SetSwitchStateCorrespondingToSavedValues(){
        let days:[Day] = Day.FetchData(appDel.managedObjectContext)!
        for d in days{
            switch d.day!{
            case lbl_MondaySwitch.text!:
                switchMonday.on = true
                break
            case lbl_TuesdaySwitch.text!:
                switchTuesday.on = true
                break
            case lbl_WensdaySwitch.text!:
                switchWensday.on = true
                break
            case lbl_ThursdaySwitch.text!:
                switchThursday.on = true
                break
            case lbl_FridaySwitch.text!:
                switchFriday.on = true
                break
            case lbl_SaturdaySwitch.text!:
                switchSaturday.on = true
                break
            default:
                break
            }
        }
    }
    
    private func createDisabledDayDeleteAlert(){
        let alert = UIAlertController(title: NSLocalizedString("EnabledDaysVC_AlertDeleteDayDisables_Title", comment: "-"), message: NSLocalizedString("EnabledDaysVC_AlertDeleteDayDisables_Message", comment: "-"), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
}
