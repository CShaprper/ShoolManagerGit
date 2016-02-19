
import UIKit
import iAd


class MainVC:UIViewController, UITabBarControllerDelegate, ADBannerViewDelegate, UITextViewDelegate {
    /*@IBOutlet    ###############################################################################################################*/
    @IBOutlet var SubjectColorView: UIView!
    @IBOutlet var nowBackgroundImageView: UIImageView!
    @IBOutlet var nowRoomLabel: UILabel!
    @IBOutlet var BackgroundImageView: UIImageView!
    @IBOutlet var nowTeacherGenderImage: UIImageView!
    @IBOutlet var nowSubjectImage: UIImageView!
    @IBOutlet var nowLabel: UILabel!
    @IBOutlet var nowTeacherLabel: UILabel!
    @IBOutlet var nowSubjectLabel: UILabel!
    @IBOutlet var nowHourLabel: UILabel!
    @IBOutlet var nowendHourLabel: UILabel!
    @IBOutlet var nowHourNumberLabel: UILabel!
    @IBOutlet var nowStack: UIStackView!
    @IBOutlet var nextStack: UIStackView!
    
    @IBOutlet var nextLabel: UILabel!
    @IBOutlet var nextHourLabel: UILabel!
    @IBOutlet var nextHourNumberLabel: UILabel!
    @IBOutlet var nextEndTimeLabel: UILabel!
    @IBOutlet var nextRoomLabel: UILabel!
    @IBOutlet var nextSubjectImageView: UIImageView!
    @IBOutlet var nextSubjectColorView: UIView!
    @IBOutlet var nextSubjectLabel: UILabel!
    @IBOutlet var nextTeacherGenderImageView: UIImageView!
    @IBOutlet var nextTeacherLabel: UILabel!
    
    @IBOutlet var InfoViewCenterXAlignment: NSLayoutConstraint!
    @IBOutlet var WelcomeLabel: UILabel!
    @IBOutlet var WelcomeTextView: UITextView!
    var counter = 0
    var selectedNowSubject:Subject!
    var selectedNextSubject:Subject!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    let transition = BounceTransition()
    var isNowStackTapped = false
    
    
    /*ViewController Delegate
    ##############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openNoteDetailWithID:", name: "openNote", object: nil)
        self.tabBarController!.delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if !appDel.adDefaults.boolForKey("purchased"){
            loadAds()
        }
        //Planer.deleteAllPlanerData(appDel.managedObjectContext)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        InfoViewCenterXAlignment.constant -= 800
        setDashBoardUI()
        setNotesBadge()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldDisplayWelcomeMessage(){
            showWelcomeMessage()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("handleNowStackTap:"))
        self.nowStack.userInteractionEnabled = true
        self.nowStack.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: Selector("handleNextStackTap:"))
        self.nextStack.userInteractionEnabled = true
        self.nextStack.addGestureRecognizer(tapGesture2)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    private func openNoteDetailWithID(){
        self.performSegueWithIdentifier("ShowNoteDetailFromMain", sender: nil)
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
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "ShowAddNotesFromMain"{
            if selectedNowSubject != nil || selectedNextSubject != nil{
                let dest = segue.destinationViewController as! AddNoteVC
                if selectedNowSubject != nil && isNowStackTapped{
                    dest.selectedSubject = selectedNowSubject
                } else if selectedNextSubject != nil && !isNowStackTapped{
                    dest.selectedSubject = selectedNextSubject
                }
            }
        }
    }
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue){
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func setDashBoardUI(){
        clearDashboardUI()
        let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: NSDate()).weekday
        print("Weekday: \(myWeekday)")
        let fetch:[Planer] = Planer.fetchPlanerObjectsWithDaySortnumberPredicate(NSNumber(integer: myWeekday ), context: appDel.managedObjectContext)!
        print(fetch)
        if fetch.count == 0{
            self.nowLabel.text = "MainVC_NowLabelText".localized
            nowBackgroundImageView.image = UIImage(named: "Freetime2")
            selectedNowSubject = nil
            selectedNextSubject = nil
        }else{
            for plan in fetch{
                let startTime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(plan.hour!.startTime!), minute: DateHelper.GetTimeAsMinute(plan.hour!.startTime!))
                let endtime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(plan.hour!.endTime!), minute: DateHelper.GetTimeAsMinute(plan.hour!.endTime!))
                let currentTime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(NSDate()), minute: DateHelper.GetTimeAsHour(NSDate()))
                
                let CurrentWeekNumber  = NSCalendar.currentCalendar().component(.WeekOfYear, fromDate: currentTime)
                let isCurrentWeekEvenWeek:Bool = CurrentWeekNumber  % 2 == 0
                
                let hourFormatter = NSDateFormatter()
                hourFormatter.dateFormat = "HH:mm"
                print("isGreaterThan: \(hourFormatter.stringFromDate(currentTime)) - \(hourFormatter.stringFromDate(startTime)) = \(DateHelper.isGreaterThanDate(currentTime, dateToCompare: startTime)) && isLessThan: \(hourFormatter.stringFromDate(currentTime)) - \(hourFormatter.stringFromDate(endtime)) = \(DateHelper.isLessThanDate(currentTime, dateToCompare: endtime))")
                if (DateHelper.isGreaterThanDate(currentTime, dateToCompare: startTime) || DateHelper.isSameToDate(currentTime, dateToCompare: startTime)) && (DateHelper.isLessThanDate(currentTime, dateToCompare: endtime) || DateHelper.isSameToDate(currentTime, dateToCompare: endtime)){
                    if isCurrentWeekEvenWeek && (plan.selectedWeek == 0 || plan.selectedWeek == 2){
                        configureNowUIElement(plan)
                        break
                    }else if !isCurrentWeekEvenWeek && (plan.selectedWeek == 1 || plan.selectedWeek == 2){
                        configureNowUIElement(plan)
                        break
                    }
                } else {
                    self.nowLabel.text = "MainVC_NowLabelText".localized
                    nowBackgroundImageView.image = UIImage(named: "Freetime2")
                }
            }
            for plan in fetch{
                let startTime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(plan.hour!.startTime!), minute: DateHelper.GetTimeAsMinute(plan.hour!.startTime!))
                let endtime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(plan.hour!.endTime!), minute: DateHelper.GetTimeAsMinute(plan.hour!.endTime!))
                let currentTime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(NSDate()), minute: DateHelper.GetTimeAsHour(NSDate()))
                
                print("isLessThan: \(NSDate.hourFormatter(currentTime)) - \(NSDate.hourFormatter(startTime)) = \(DateHelper.isLessThanDate(currentTime, dateToCompare: startTime)) && isLessThan: \(NSDate.hourFormatter(currentTime)) - \(NSDate.hourFormatter(endtime)) = \(DateHelper.isLessThanDate(currentTime, dateToCompare: endtime))")
                if DateHelper.isLessThanDate(currentTime, dateToCompare: startTime) && DateHelper.isLessThanDate(currentTime, dateToCompare: endtime){
                    configureNextUIElement(plan)
                    break
                }
            }
        }
    }
    func configureNowUIElement(plan:Planer){
        self.nowLabel.text = "MainVC_NowLabelText".localized
        self.nowSubjectImage.image = UIImage(named: plan.subject!.imageName!)
        self.nowSubjectLabel.text = plan.subject!.subject!
        self.nowTeacherGenderImage.image = UIImage(named: plan.teacher!.iamgeName!)!
        self.SubjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: plan.subject!.color!)
        self.SubjectColorView.layer.cornerRadius = 5
        self.nowRoomLabel.text = "\("MainVC_NowRoomLabelText".localized) \(plan.room!)"
        self.nowTeacherLabel.text = plan.teacher!.name!
        self.nowBackgroundImageView.image = nil
        self.nowHourNumberLabel.text = "\(plan.hour!.hour!)."
        self.nowHourLabel.text = "\("MainVC_NowHourStartLabelText".localized)  \(NSDate.hourFormatter(plan.hour!.startTime!))"
        self.nowendHourLabel.text = "\("MainVC_NowHourEndLabelText".localized) \(NSDate.hourFormatter(plan.hour!.endTime!))"
        selectedNowSubject = plan.subject
    }
    func configureNextUIElement(plan:Planer){
        self.nextLabel.text = NSLocalizedString("MainVC_NextLabelText", comment: "-")
        self.nextSubjectImageView.image = UIImage(named: plan.subject!.imageName!)
        self.nextSubjectLabel.text = plan.subject!.subject!
        self.nextTeacherGenderImageView.image = UIImage(named: plan.teacher!.iamgeName!)!
        self.nextSubjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: plan.subject!.color!)
        self.nextSubjectColorView.layer.cornerRadius = 5
        self.nextRoomLabel.text = "\("MainVC_NowRoomLabelText".localized) \(plan.room!)"
        self.nextTeacherLabel.text = plan.teacher!.name!
        self.nextHourNumberLabel.text = "\(plan.hour!.hour!)."
        self.nextHourLabel.text = "\("MainVC_NowHourStartLabelText".localized) \(NSDate.hourFormatter(plan.hour!.startTime!))"
        self.nextEndTimeLabel.text = "\("MainVC_NowHourEndLabelText".localized) \(NSDate.hourFormatter(plan.hour!.endTime!))"
        selectedNextSubject = plan.subject!
    }
    
    private func clearDashboardUI(){
        self.nowLabel.text = ""
        self.nowHourLabel.text = ""
        self.nowSubjectLabel.text = ""
        self.nowTeacherLabel.text = ""
        self.nowRoomLabel.text = ""
        self.nowendHourLabel.text = ""
        self.nowHourNumberLabel.text = ""
        self.SubjectColorView.backgroundColor = UIColor.clearColor()
        self.nowBackgroundImageView.image = nil
        self.nowSubjectImage.image = nil
        self.nowTeacherGenderImage.image = nil
        
        self.nextLabel.text = ""
        self.nextHourLabel.text = ""
        self.nextRoomLabel.text = ""
        self.nextSubjectImageView.image = nil
        self.nextSubjectColorView.backgroundColor = UIColor.clearColor()
        self.nextSubjectLabel.text = ""
        self.nextTeacherGenderImageView.image = nil
        self.nextTeacherLabel.text = ""
        self.nextHourNumberLabel.text = ""
        self.nextEndTimeLabel.text = ""
    }
    
    @IBAction func hideWelcomeMessageAction() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.InfoViewCenterXAlignment.constant -= 800
            self.view.layoutIfNeeded()
            }, completion: { (hideWelcomeMessageAction) -> Void in self.tabBarController?.selectedIndex = 3 })
    }
    private func showWelcomeMessage(){
        WelcomeLabel.text = "DashboardWelcomeHeader".localized
        WelcomeTextView.text = "DashboardWelcomeMessage".localized
        UIView.animateWithDuration(1.0, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.InfoViewCenterXAlignment.constant += 800
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func shouldDisplayWelcomeMessage()->Bool{
        let teachers = Teacher.FetchData(appDel.managedObjectContext)
        let days = Day.FetchData(appDel.managedObjectContext)
        let subjects = Subject.FetchData(appDel.managedObjectContext)
        let timeline = TimelineData.FetchData(appDel.managedObjectContext)
        if teachers!.count == 0 || days!.count == 0 || subjects!.count == 0 || timeline!.count == 0{
            return true
        } else { return false }
    }
    
    private func setNotesBadge(){
        let notes = Note.FetchData(appDel.managedObjectContext)
        let tabBarController = appDel.window?.rootViewController as! UITabBarController
        let tabBarRootViewControllers: Array = tabBarController.viewControllers!
        if notes!.count > 0{
            tabBarRootViewControllers[2].tabBarItem.badgeValue = "\(notes!.count)"
        } else {
            tabBarRootViewControllers[2].tabBarItem.badgeValue = nil
        }
    }
    
    func handleNowStackTap(sender: UITapGestureRecognizer? = nil) {
        if selectedNowSubject != nil {
            isNowStackTapped = true
            self.performSegueWithIdentifier("ShowAddNotesFromMain", sender: selectedNowSubject)
        }
    }
    
    func handleNextStackTap(sender: UITapGestureRecognizer? = nil) {
        if selectedNextSubject != nil{
            isNowStackTapped = false
            self.performSegueWithIdentifier("ShowAddNotesFromMain", sender: selectedNextSubject)
        }
    }
    
}
