
import UIKit
import iAd

class TimeTableElement{
    var tld:TimelineData?
    var planerElements: [Planer] = [Planer]()
}

class TimeTableVC: UIViewController, UITabBarControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate, UITextViewDelegate {
    /*MARK: Outlet / Member    ###############################################################################################################*/
    
    @IBOutlet var infoMessageCenterConstraint: NSLayoutConstraint!
    @IBOutlet var infoMessageTextView: UITextView!
    @IBOutlet var infoMessageHeader: UILabel!
    @IBOutlet var TitleLable: UILabel!
    @IBOutlet var TimetableCollectionView: UICollectionView!
    @IBOutlet var BackgroundImageView: UIImageView!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var timeTableCollection:[TimeTableElement]!
    let transition = BounceTransition()
    var isEditAction:Bool!
    var isCurrentUIWeekSwitched:Bool = false
    var isAddAction:Bool!
    var currentTime:NSDate!
    var CurrentWeekNumber:Int!
    var isCurrentWeekEven:Bool!
    var iscurrentUIWeekEven:Bool!
    var hours:[TimelineData]!
    var selectedPlanerElement:Planer!
    var counter:Int = 0
    
    
    /*MARK: ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        TimetableCollectionView.backgroundColor = UIColor.clearColor()
        currentTime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(NSDate()), minute: DateHelper.GetTimeAsHour(NSDate()))
        // Initialize the Ad
        if !appDel.userDefaults.boolForKey("com.petersypek.SchoolManager"){
            loadAds()
            UIViewController.prepareInterstitialAds()
        }
        
        // loadAds()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.isEditAction = false
        self.isAddAction = false
        self.infoMessageCenterConstraint.constant = -800
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadTimeTableCollection(iscurrentUIWeekEven)
        if !appDel.userDefaults.boolForKey("FirstTimeplanerVisit"){
            let result = Day.FetchData(appDel.managedObjectContext)
            let res = HoursPerDayData.FetchData(appDel.managedObjectContext)
            let result2 = TimelineData.FetchData(appDel.managedObjectContext)
            let result3 = Teacher.FetchData(appDel.managedObjectContext)
            let result4 = Subject.FetchData(appDel.managedObjectContext)
            if (result!.count > 0 || res!.count > 0 || result2!.count > 0 || result3!.count > 0 || result4!.count > 0) {
                showWelcomeMessage()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
    return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
    
    /*MARK: CollectionView Delegates    ###############################################################################################################*/
    let reuseidentifier = "TimePlanerCell"
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseidentifier, forIndexPath: indexPath) as? TimePlanerCell{
            cell.configureCell(timeTableCollection[indexPath.section], indexPath: indexPath)
            return cell
        }else{
            return TimePlanerCell()
        }
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 && indexPath.section != 0{
            let tte = timeTableCollection[indexPath.section].planerElements[indexPath.row]
            if tte.isEmptyElement as! Bool{
                self.isAddAction = true
                self.isEditAction = false
                self.performSegueWithIdentifier("ShowPlanerSetup", sender: indexPath)
            }else{
                createActionSheetAlert(tte)
            }
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if !isCurrentUIWeekSwitched{
            currentTime = DateHelper.createDateFromComponents(2016, month: 01, day: 01, hour: DateHelper.GetTimeAsHour(NSDate()), minute: DateHelper.GetTimeAsHour(NSDate()))
            CurrentWeekNumber  = NSCalendar.currentCalendar().component(.WeekOfYear, fromDate: currentTime)
            isCurrentWeekEven = CurrentWeekNumber  % 2 == 0
            iscurrentUIWeekEven = isCurrentWeekEven
        }
        loadTimeTableCollection(iscurrentUIWeekEven)
        return timeTableCollection.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  timeTableCollection[section].planerElements.count
    }
    
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if !appDel.userDefaults.boolForKey("com.petersypek.SchoolManager"){
            counter++
            if counter == 3 {
                counter = 0
                let destination = segue.destinationViewController
                destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic
            }
        }
        if segue.identifier == "ShowAddNotesFromTimeTable"{
            if let dest = segue.destinationViewController as? AddNoteVC{
                let p = sender as! Planer
                dest.setUISubject(p.subject!)
                dest.transitioningDelegate = transition
            }
        }
        if self.isEditAction!{
            if let editElement:Planer? = sender as? Planer{
                if  editElement != nil && editElement!.isEmptyElement as! Bool == false{
                    if let dest = segue.destinationViewController as? PlanerSetupVC{
                        dest.planerToEdit = editElement!
                        dest.isEditAction = self.isEditAction
                        dest.transitioningDelegate = transition
                    }
                }
            }
        }else if self.isAddAction!{
            if let indexP:NSIndexPath? = sender as? NSIndexPath{
                if let dest = segue.destinationViewController as? PlanerSetupVC{
                    dest.indexPath = indexP!
                    dest.isAddAction = self.isAddAction
                    dest.transitioningDelegate = transition
                }
            }
        }
    }
    @IBAction func unwindToTimeTable(segue:UIStoryboardSegue){
        loadTimeTableCollection(self.iscurrentUIWeekEven)//
    }
    
    
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func loadTimeTableCollection(isCurrentWeekEven:Bool){
        if isCurrentWeekEven{
            self.TitleLable.text = "TimeTableTitleOdd".localized
        } else {
            self.TitleLable.text = "TimeTableTitleUneven".localized
        }
        timeTableCollection = [TimeTableElement]()
        let days = Day.FetchData(appDel.managedObjectContext)!
        let tldCollection = TimelineData.FetchData(appDel.managedObjectContext)!
        print(tldCollection)
        
        var isVeryFirstElement = true
        //Iterate all hours / TimeLindeData for Section Headers
        for tld in tldCollection{
            print(tld.hour)
            //VeryFirstElement needs to be empty
            if isVeryFirstElement{
                //Create TimeTableElement for each Timeline hour to append to TableViewCollection
                let tte:TimeTableElement = TimeTableElement()
                //Set the tld.hour / Section value of TimeTableElement
                tte.tld = tld
                //Create and append veryFirstPlanerelement
                let ele0 = createPlanerElement(tld, day: nil, isEmptyElement:true, isHeaderElement: true)
                tte.planerElements.append(ele0)
                //Iterate all days to create DayHeaderElements
                for day in days{
                    //Create and append DayHeaderelements
                    let eled = createPlanerElement(nil, day: day, isEmptyElement:false, isHeaderElement: true)
                    tte.planerElements.append(eled)
                }
                //Set isVeryFirstElement = false when it is setup with element
                isVeryFirstElement = false
                timeTableCollection.append(tte)
            }
            //Create TimeTableElement for each Timeline hour to append to TableViewCollection
            let tte:TimeTableElement = TimeTableElement()
            //Set the tld.hour / Section value of TimeTableElement
            tte.tld = tld
            //Create and append HourHeader element
            let sec = createPlanerElement(tld, day: nil, isEmptyElement:false, isHeaderElement: true)
            tte.planerElements.append(sec)
            
            //Append planer elements for current hour and day
            for d in days{
                let planerElements:[Planer] = Planer.fetchDataWithDaystringPredicate(d.day!, context: appDel.managedObjectContext)!
                
                let pElements:[Planer] = planerElements.filter({$0.hour!.hour! ==  tld.hour!} )
                print("\(pElements.count) planerElements filtered for day \(d.day!) hour \(tld.hour!)")
                let bothPElements:[Planer]!
                let totalPElements:[Planer]!
                print("iscurrentWeekEven ? \(isCurrentWeekEven)")
                if isCurrentWeekEven{
                    bothPElements = pElements.filter({$0.selectedWeek! == 2})
                    print("\(bothPElements.count) filtered with dayselector both")
                    totalPElements = pElements.filter({$0.selectedWeek! == 0 })
                    print("\(totalPElements.count) filtered with dayselector even")
                    totalPElements.appendContentsOf(bothPElements)
                }else{
                    bothPElements = pElements.filter({$0.selectedWeek! == 2})
                    print("\(bothPElements.count) filtered with dayselector both")
                    totalPElements = pElements.filter({$0.selectedWeek! == 1 })
                    print("\(totalPElements.count) filtered with dayselector uneven")
                    totalPElements.appendContentsOf(bothPElements)
                }
                print("totalPElements.count = \(totalPElements.count)")
                
                if totalPElements.count > 0{
                    // Hour is set inside day
                    tte.planerElements.append(totalPElements[0])
                }else{
                    // Hour is not set inside day
                    let ele = createPlanerElement(tld, day: d, isEmptyElement:true, isHeaderElement: false)
                    tte.planerElements.append(ele)
                }
            }
            //Append TimeTableElement to TableViewCollection
            //TimeTableElement is holding tld.hour as Sections and tte.planerElements[] as days
            timeTableCollection.append(tte)
        }
        TimetableCollectionView.reloadData()
    }
    
    func createPlanerElement(hour:TimelineData?, day:Day?, isEmptyElement:Bool, isHeaderElement:Bool)->Planer{
        let ele = Planer.InsertIntoManagedObjectContext(appDel.managedObjectContext)
        ele.day = day
        ele.isEmptyElement = isEmptyElement
        ele.isHeaderElement = isHeaderElement
        ele.hour = hour
        ele.subject = nil
        ele.teacher = nil
        ele.room = nil
        return ele
    }
    
    private func switchCurrentUIWeek(){
        isCurrentUIWeekSwitched = true
        if self.iscurrentUIWeekEven!{
            self.TitleLable.text = "TimeTableTitleUneven".localized
            self.iscurrentUIWeekEven = false
        }else {
            self.TitleLable.text = "TimeTableTitleOdd".localized
            self.iscurrentUIWeekEven = true
        }
        self.loadTimeTableCollection(self.iscurrentUIWeekEven)
    }
    
    @IBAction func longPressAction(sender: AnyObject) {
        let alert = UIAlertController(
            title: "Alert_Delete_Title".localized, message: "TimeTableVC_DeleteCompleteTimeTable".localized, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "TimeTableVC_DeleteAll".localized, style: .Destructive, handler: {  (action: UIAlertAction)-> Void in
            Planer.deleteAllPlanerData(self.appDel.managedObjectContext)
            self.loadTimeTableCollection(self.iscurrentUIWeekEven)
        }))
        alert.addAction(UIAlertAction(title: "TimeTableVC_SwitchWeek".localized, style: .Default, handler: {  (action: UIAlertAction)-> Void in
            self.switchCurrentUIWeek()
        }))
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Cancel, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createActionSheetAlert(timetableElement:Planer){
        let alert = UIAlertController(
            title: "ActionSheet_ElementAction_Title".localized, message: "TimeTableVC_PossibleActions".localized, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "\("TimeTableVC_AddNote".localized) \(timetableElement.subject!.subject!)", style: .Default, handler: { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier("ShowAddNotesFromTimeTable", sender: timetableElement)
        }))
        alert.addAction(UIAlertAction(title: "\("Alert_Action_Edit".localized) \(timetableElement.subject!.subject!) \("PlanerSetup_OnDay_Message".localized) \(timetableElement.daystring!)", style: .Default, handler: { (UIAlertAction) -> Void in
            self.isEditAction = true
            self.performSegueWithIdentifier("ShowPlanerSetup", sender: timetableElement)
        }))
        alert.addAction(UIAlertAction(title: "\("Alert_Action_Delete".localized) \(timetableElement.subject!.subject!) \("PlanerSetup_OnDay_Message".localized) \(timetableElement.daystring!)", style: .Destructive, handler: {  (action: UIAlertAction)-> Void in
            Planer.DeletePlanerObject(timetableElement, context: self.appDel.managedObjectContext)
            self.loadTimeTableCollection(self.iscurrentUIWeekEven)
        }))
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Cancel, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    private func showWelcomeMessage(){
        infoMessageHeader.text = "TimeTableWelcomeHeader".localized
        infoMessageTextView.text = "TimeTableWelcomeMessage".localized
        UIView.animateWithDuration(1.0, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.infoMessageCenterConstraint.constant += 800
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    @IBAction func hideWelcomeMessageButton() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        self.infoMessageCenterConstraint.constant -= 800
        self.view.layoutIfNeeded()
        }, completion: { (hideWelcomeMessageAction) -> Void in self.appDel.userDefaults.setBool(true, forKey: "FirstTimeplanerVisit")})
    }
}
