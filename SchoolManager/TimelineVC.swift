
import UIKit
import CoreData
import iAd

class TimelineVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, ADBannerViewDelegate {
    
    /* MARK: @IBOutlet & Menbers
    ###############################################################################################################*/
    @IBOutlet var StartTimePicker: UIDatePicker!
    @IBOutlet var EndTimePicker: UIDatePicker!
    @IBOutlet var HoursPicker: UIPickerView!
    @IBOutlet var TimeLineDataTableView: UITableView!
    @IBOutlet var BackgroundImageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
    
    /*MARK: Members
    ###############################################################################################################*/
    var selectedStartDate:NSDate = NSDate()
    var SelectedEndDate:NSDate = NSDate()
    var SelectedHoursPickerValue: String = "1"
    var SelectedTimeLineData:TimelineData!
    
    //TimeLineData Array for CoreData fetches
    var timelineDataArray:[TimelineData]!
    
    //HoursPerDay Array for Core Data Fetches
    var HoursPerDayDataArray:[HoursPerDayData]!
    
    //HoursPerDay Array for Core Data Fetches
    var HoursPerDayPickerArray:[String] = []
    
    //AppDelegate Object
    let appDel = UIApplication.sharedApplication().delegate  as! AppDelegate
    
    //Selected TimelineDataRowIndex
    //Set to 0 because if no selection is made auto value is first element
    var SelectedTimelineDatoRowIndex:Int = 0
    var layers:[CALayer] = [CALayer]()
    
    
    /* MARK: View Delegates
    ############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.boolForKey("com.petersypek.SchoolManager"){
            loadAds()
        }
        StartTimePicker.date = NSDate()
        EndTimePicker.date = NSDate()
        HoursPicker.delegate = self
        HoursPicker.dataSource = self
        TimeLineDataTableView.delegate = self
        TimeLineDataTableView.dataSource = self
        popoverPresentationController?.delegate = self
        TimeLineDataTableView.backgroundColor  = UIColor.clearColor()
        EndTimePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        StartTimePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        StartTimePicker.layer.borderWidth = 2
        StartTimePicker.layer.borderColor = UIColor.whiteColor().CGColor
        StartTimePicker.layer.cornerRadius = 15
        EndTimePicker.layer.borderWidth = 2
        EndTimePicker.layer.borderColor = UIColor.whiteColor().CGColor
        EndTimePicker.layer.cornerRadius = 15
        HoursPicker.layer.borderWidth = 2
        HoursPicker.layer.borderColor = UIColor.whiteColor().CGColor
        HoursPicker.layer.cornerRadius = 15
        self.layers.append(saveButton.layer)
        UIDesignHelper.ShadowMakerMultipleLayers(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(15), layers: layers)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SetHoursPerDayPickerElementCount()
        ReloadTableView()
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
    
    /* MARK: UIPicker Delegate
    ###############################################################################################################*/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return HoursPerDayPickerArray[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let fetchresult:[HoursPerDayData] = HoursPerDayData.FetchData(appDel.managedObjectContext)!
        if fetchresult.count > 0{
            SetHoursPerDayPickerElementCount()
            return HoursPerDayPickerArray.count
        }else{
            return 0
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("SelectedHourPicker changed: \(HoursPerDayPickerArray[row])")
        SelectedHoursPickerValue = HoursPerDayPickerArray[row]
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: HoursPerDayPickerArray[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
    /* MARK: TableView Delegates
    ###############################################################################################################*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow
        self.SelectedTimeLineData = self.timelineDataArray[indexPath.row]
        self.SelectedTimelineDatoRowIndex = indexPath.row
        createActionSheetAlert(SelectedTimeLineData)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if timelineDataArray?.count > 0{
            if let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as? TimelineCell {
                cell.CofigureCell(timelineDataArray![indexPath.row])
                
                cell.backgroundColor = UIColor.clearColor()
                return cell
            }
            else{
                return TimelineCell()
            }
        }
        else { return TimelineCell() }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineDataArray!.count
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            TimelineData.DeleteTimelineData(timelineDataArray[indexPath.row], context: appDel.managedObjectContext)
            timelineDataArray.removeAtIndex(indexPath.row)
            TimeLineDataTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    /*  MARK: - Navigation Prepare For Segue    ##############################################################################################################*/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? EditTimelinePopUpVC, popPC = dest.popoverPresentationController{
            // Set Properties on destination ViewController
            dest.myTimeLineDataToEdit = self.SelectedTimeLineData
            dest.myHoursPickerSource = self.HoursPerDayPickerArray
            dest.myHoursPickerSource   = self.HoursPerDayPickerArray
            dest.SelectedPickerRowIndex = self.SelectedTimelineDatoRowIndex
            popPC.delegate = self
        }
    }
    @IBAction func unwindToNewTimeline(segue:UIStoryboardSegue){
        ReloadTableView()
    }
    
    /* MARK: @IBActions
    ###############################################################################################################*/
    @IBAction func StartTimePickerChanged(sender: UIDatePicker) {
        self.selectedStartDate = sender.date
        print("StartDatePicker changed: \(sender.date)")
    }
    @IBAction func EndTimePickerChanged(sender: UIDatePicker) {
        self.SelectedEndDate = sender.date
        print("EndDatePicker changed: \(sender.date)")
    }
    @IBAction func saveTimelineDataAction(sender: AnyObject) {
        let allData:[TimelineData] = TimelineData.FetchData(appDel.managedObjectContext)!
        if  Int(SelectedHoursPickerValue)! <= allData.count {
            let alert = UIAlertController(title: "Alert_WrongUserInput_Title".localized, message: "TimelineVC_AlertHourNumberColliding_Message".localized, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var cnt:Int = allData.count
        cnt-=1
        if allData.count > 0{
            let result = TimelineData.collidesWithExistingTimelineData(cnt, allData: allData , cStartDate: selectedStartDate, cEndDate: SelectedEndDate)
            if  result == CollidingTime.collidesWithExistingTime{
                let alert = UIAlertController(title: "Alert_WrongUserInput_Title".localized, message: "TimelineVC_AlertTimePeriodColliding_Message".localized , preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                return
            }else if result == CollidingTime.startTimeIsBiggerThanEndTime{
                let alert = UIAlertController(title: "Alert_WrongUserInput_Title".localized, message: "TimelineVC_AlertStartTimeSmallerThanEndTime_Message".localized , preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        // Save TimelineData
        TimelineData.SaveTimelineData(self.CastStringToNSNumber(SelectedHoursPickerValue)!, starttime: selectedStartDate, endtime: SelectedEndDate, context: appDel.managedObjectContext)
        ReloadTableView()
    }
    
    
    /*MARK: Helper Functions
    ##############################################################################################################*/
    func ReloadTableView(){
        self.timelineDataArray = TimelineData.FetchData(appDel.managedObjectContext)
        self.TimeLineDataTableView.reloadData()
        self.TimeLineDataTableView.AnimateTable()
    }
    
    func createActionSheetAlert(selectedElement:TimelineData){
        let alert = UIAlertController(
            title: "ActionSheet_ElementAction_Title".localized, message: "TimelineVC_ActionSheetTimeTableActions_Message".localized, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Alert_Action_Edit".localized + " \(selectedElement.hour!)", style: .Default, handler: { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier("ShowEditTimelinePopOver", sender:  selectedElement)
        }))
        let plans = Planer.fetchNotEmptyPlanerElementsWithHour(selectedElement.hour!, context: appDel.managedObjectContext)!
        print(plans.count)
        if plans.count == 0{
            alert.addAction(UIAlertAction(title: "Alert_Action_Delete".localized + " \(selectedElement.hour!)", style: .Destructive, handler: {  (action: UIAlertAction)-> Void in
                TimelineData.DeleteTimelineData(selectedElement, context: self.appDel.managedObjectContext)
                self.ReloadTableView()
            }))
        }
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Cancel, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /**Sets the number of Elemets in the HoursPerDayArray
     to the int value of HoursPerDay property
     - Resets the element count to 0 before appending new elements*/
    private func SetHoursPerDayPickerElementCount(){
        //Fetch the HoursPerDay from Core Data
        HoursPerDayDataArray = HoursPerDayData.FetchData(appDel.managedObjectContext)
        if HoursPerDayDataArray != nil && HoursPerDayDataArray.count > 0{
            //Reset the HoursPerDayPickerArray
            self.HoursPerDayPickerArray.removeAll()
            //Cast the String HoursPerDayCount Value to integer value
            let num:Int = Int(HoursPerDayDataArray![0].hoursCount!)!
            for i in 1...num{
                //Append each hour to HoursPerDayPicker Array as single number String value
                self.HoursPerDayPickerArray.append("\(i)")
            }
        }
    }
}
