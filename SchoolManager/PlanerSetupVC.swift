
import UIKit
import iAd

class PlanerSetupVC: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, ADBannerViewDelegate   {
    /*Outlets / Member
    ###############################################################################################################*/
    @IBOutlet var SelectTeacherLabel: UILabel!
    @IBOutlet var SelectDayLabel: UILabel!
    @IBOutlet var SelectHourLabel: UILabel!
    @IBOutlet var SelectSubjectLabel: UILabel!
    @IBOutlet var RoomTextField: UITextField!
    @IBOutlet var BackgroundImageView: UIImageView!
    @IBOutlet var SubjectColorView: UIView!
    @IBOutlet var weekSegementControl: UISegmentedControl!
    @IBOutlet var saveButton: UIButton!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var isEditAction:Bool = false
    var isAddAction:Bool = false
    var selectedRoom:String!
    var selectedTeacher:Teacher?
    var selectedDay:Day?
    var selectedHour:TimelineData?
    var selectedSubject:Subject?
    var planerCollection:[Planer]!
    let transition = BounceTransition()
    var planerToEdit:Planer!
    var indexPath = NSIndexPath()
    var selectedWeekSegment:Int = -1
    /*ViewController Delegate
    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.boolForKey("com.petersypek.SchoolManager"){
            loadAds()
        }
        popoverPresentationController?.delegate = self
        RoomTextField.delegate = self
        self.SubjectColorView.layer.cornerRadius = 5
        self.weekSegementControl.selectedSegmentIndex = -1
        self.selectedWeekSegment = -1
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setEditActionUIValues()
    }
    //Textfield Delegate
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func shouldAutorotate() -> Bool {
        return false
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
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue from: \(segue.sourceViewController.title!) to: \(segue.destinationViewController.title!)")
        if let dest = segue.destinationViewController as? SelectTeacherVC,
            popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? SelectDayVC,
            popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? SelectHourVC,
            popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? SelectSubjectVC,
            popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? TimeTableVC{
            dest.unwindToTimeTable(segue)
            dest.transitioningDelegate = transition
        }
    }
    @IBAction func unwindToPlanerSetup(segue: UIStoryboardSegue){
        if let _ = segue.sourceViewController as? SelectTeacherVC{
            print("Selected Teacher: \(selectedTeacher!.name!)")
            self.SelectTeacherLabel.text = self.selectedTeacher!.name
        }
        if let _ = segue.sourceViewController as? SelectSubjectVC{
            print("Selected Subject: \(selectedSubject!.subject!)")
            self.SelectSubjectLabel.text = self.selectedSubject!.subject
            self.SubjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: self.selectedSubject!.color!)
        }
        if let _ = segue.sourceViewController as? SelectDayVC{
            print("Selected Day: \(selectedDay!.day!)")
            self.SelectDayLabel.text = self.selectedDay!.day
        }
        if let _ = segue.sourceViewController as? SelectHourVC{
            print("Selected Hour: \(selectedHour!.hour!) \("MainVC_NowHourStartLabelText".localized) \(self.GetTimeAsHour(self.selectedHour!.startTime!)) \("MainVC_NowHourEndLabelText".localized) \(self.GetTimeAsMinute(selectedHour!.endTime!))")
            self.SelectHourLabel.text = "\(self.selectedHour!.hour!). \("MainVC_NowHourStartLabelText".localized) \(NSDate.hourFormatter(self.selectedHour!.startTime!)) \("MainVC_NowHourEndLabelText".localized) \(NSDate.hourFormatter(self.selectedHour!.endTime!))"
        }
    }
    
    /*MARK: @IBActions    ###############################################################################################################*/
    
    @IBAction func weekSegmentChanged(sender: UISegmentedControl) {
        selectedWeekSegment = sender.selectedSegmentIndex
    }
    @IBAction func SaveButtonAction() {
        textFieldShouldReturn(RoomTextField)
        
        if RoomTextField.text != nil && RoomTextField.text == ""{
            let alert = UIAlertController( title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingRoom_Message".localized, preferredStyle: .Alert )
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if selectedSubject == nil{
            let alert = UIAlertController(title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingSubject_Message".localized,preferredStyle: .Alert )
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil) )
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if selectedTeacher == nil{
            let alert = UIAlertController(title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingTeacher_Message".localized, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if selectedHour == nil{
            let alert = UIAlertController( title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingHour_Message".localized,preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if selectedDay == nil{
            let alert = UIAlertController( title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingDay_Message".localized,preferredStyle: .Alert )
            alert.addAction(UIAlertAction(title: "OK", style: .Default,handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        if selectedWeekSegment == -1{
            let alert = UIAlertController( title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingWeeknumber_Message".localized, preferredStyle: .Alert )
            alert.addAction(UIAlertAction(title: "OK", style: .Default,handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        if self.isEditAction{
            planerToEdit.daystring = selectedDay!.day!
            planerToEdit.hour = selectedHour
            planerToEdit.subject = selectedSubject
            planerToEdit.teacher = selectedTeacher
            planerToEdit.day = selectedDay
            planerToEdit.room = RoomTextField.text
            planerToEdit.isEmptyElement = false
            planerToEdit.selectedWeek = selectedWeekSegment
            Planer.EditPlanerObject(planerToEdit, context: appDel.managedObjectContext)
            self.isEditAction = false
            self.performSegueWithIdentifier("unwindToTimeTable", sender: nil)
        }else if self.isAddAction{
            print("selectedWeekSegment: \(selectedWeekSegment) selectedDay: \((selectedDay?.day)!)")
            let planer = Planer.fetchExistingPlanerElement(selectedHour!.hour!, day: selectedDay!.day!,context: appDel.managedObjectContext)
            if planer!.count > 0 && (selectedWeekSegment  == 2  || planer![0].selectedWeek == selectedWeekSegment) {
                let alert = UIAlertController(title: "Alert_AddingDisabled_Title".localized, message: "\("PlanerSetup_Hour_Message".localized) \(selectedHour!.hour!) \("PlanerSetup_HourOnDay_Message".localized) \(selectedDay!.day!) \("PlanerSetup_HourCollides_Message".localized) \((planer?[0].subject?.subject)!) \("PlanerSetup_AtTime_Message".localized) \((planer?[0].hour?.hour)!). \((planer?[0].hour?.startTime)!) - \((planer?[0].hour?.endTime)!) \("PlanerSetup_OnDay_Message".localized) \((planer?[0].day?.day)!) \("PlanerSetup_RestMessage".localized)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }else{
                Planer.savePlaner(false, strRoom: RoomTextField.text!, selectedWeek: selectedWeekSegment, subject: selectedSubject!, hour: selectedHour!, day: selectedDay!, teacher: selectedTeacher!, context: appDel.managedObjectContext)
                resetPlanerUIAndSelectedValues()
                self.performSegueWithIdentifier("unwindToTimeTable", sender: nil)
            }
        }
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func setEditActionUIValues(){
        if isEditAction{
            self.selectedDay = planerToEdit.day!
            self.selectedHour = planerToEdit.hour!
            self.selectedTeacher = planerToEdit.teacher!
            self.selectedRoom = planerToEdit.room!
            self.selectedSubject = planerToEdit.subject!
            self.RoomTextField.text = planerToEdit.room!
            self.selectedWeekSegment = planerToEdit.selectedWeek!.integerValue
            self.weekSegementControl.selectedSegmentIndex = planerToEdit.selectedWeek!.integerValue
            self.SelectDayLabel.text = planerToEdit.day!.day!
            self.SelectTeacherLabel.text = planerToEdit.teacher!.name!
            self.SelectSubjectLabel.text = planerToEdit.subject!.subject!
            self.SelectHourLabel.text = "\("PlanerSetup_Hour".localized) \(planerToEdit.hour!.hour!) \("MainVC_NowHourStartLabelText".localized) \(NSDate.hourFormatter(planerToEdit.hour!.startTime!)) \("MainVC_NowHourEndLabelText".localized) \(NSDate.hourFormatter(planerToEdit.hour!.endTime!))"
            self.SubjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: planerToEdit.subject!.color!)
            self.isAddAction = false
        }else if isAddAction{
            let days = Day.FetchData( appDel.managedObjectContext)
            let hours = TimelineData.FetchData(appDel.managedObjectContext) 
            self.selectedHour = hours![indexPath.section - 1]
            self.selectedDay = days![indexPath.row - 1]
            self.SelectHourLabel.text = "\("PlanerSetup_Hour".localized) \(selectedHour!.hour!) \("MainVC_NowHourStartLabelText".localized) \(NSDate.hourFormatter(selectedHour!.startTime!)) \("MainVC_NowHourEndLabelText".localized) \(NSDate.hourFormatter(selectedHour!.endTime!))"
            self.SelectDayLabel.text = selectedDay!.day!
            self.isEditAction = false
        }
    }
    
    func resetPlanerUIAndSelectedValues(){
        self.selectedDay = nil
        self.selectedHour = nil
        self.selectedSubject = nil
        self.selectedTeacher = nil
        self.isEditAction = false
        self.isAddAction = false
        
        self.SelectDayLabel.text = "PlanerSetup_MissingDay_Message".localized
        self.SelectHourLabel.text = "PlanerSetup_MissingHour_Message".localized
        self.SelectSubjectLabel.text = "PlanerSetup_MissingSubject_Message".localized
        self.SelectSubjectLabel.backgroundColor = UIColor.clearColor()
        self.SelectTeacherLabel.text = "PlanerSetup_MissingTeacher_Message".localized
        self.RoomTextField.text = ""
        self.SubjectColorView.backgroundColor = UIColor.clearColor()
        self.weekSegementControl.selectedSegmentIndex = -1
        self.selectedWeekSegment = -1
    }
}
