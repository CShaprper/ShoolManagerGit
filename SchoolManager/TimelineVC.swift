
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
    let appDel = UIApplication.shared.delegate  as! AppDelegate
    
    //Selected TimelineDataRowIndex
    //Set to 0 because if no selection is made auto value is first element
    var SelectedTimelineDatoRowIndex:Int = 0
    var layers:[CALayer] = [CALayer]()
    
    
    /* MARK: View Delegates
    ############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.bool(forKey: appDel.removeAdsIdentifier){
            loadAds()
        }
        StartTimePicker.date = NSDate() as Date
        EndTimePicker.date = NSDate() as Date
        HoursPicker.delegate = self
        HoursPicker.dataSource = self
        TimeLineDataTableView.delegate = self
        TimeLineDataTableView.dataSource = self
        popoverPresentationController?.delegate = self
        TimeLineDataTableView.backgroundColor  = UIColor.clear
        EndTimePicker.setValue(UIColor.white, forKey: "textColor")
        StartTimePicker.setValue(UIColor.white, forKey: "textColor")
        StartTimePicker.layer.borderWidth = 2
        StartTimePicker.layer.borderColor = UIColor.white.cgColor
        StartTimePicker.layer.cornerRadius = 15
        EndTimePicker.layer.borderWidth = 2
        EndTimePicker.layer.borderColor = UIColor.white.cgColor
        EndTimePicker.layer.cornerRadius = 15
        HoursPicker.layer.borderWidth = 2
        HoursPicker.layer.borderColor = UIColor.white.cgColor
        HoursPicker.layer.cornerRadius = 15
        self.layers.append(saveButton.layer)
        UIDesignHelper.ShadowMakerMultipleLayers(shadowColor: UIColor.black, shadowOffset: CGFloat(15), shadowRadius: CGFloat(15), layers: layers)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetHoursPerDayPickerElementCount()
        ReloadTableView()
    }
/*TODO: Overwork
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }*/
    
    /*MARK: Advertising    ###############################################################################################################*/
    func loadAds(){
        self.appDel.adBannerView.removeFromSuperview()
        self.appDel.adBannerView.delegate = nil
        self.appDel.adBannerView = ADBannerView(frame: CGRect.zero)
        
        //ADBanner at the screen Bottom
        self.appDel.adBannerView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - self.appDel.adBannerView.frame.size.height / 2)
        
        self.appDel.adBannerView.delegate = self
        self.appDel.adBannerView.isHidden = true
        view.addSubview(self.appDel.adBannerView)
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.appDel.adBannerView.isHidden = true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDel.adBannerView.isHidden = false
    }
    
    /* MARK: UIPicker Delegate
    ###############################################################################################################*/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return HoursPerDayPickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let fetchresult:[HoursPerDayData] = HoursPerDayData.FetchData(context: appDel.managedObjectContext)!
        if fetchresult.count > 0{
            SetHoursPerDayPickerElementCount()
            return HoursPerDayPickerArray.count
        }else{
            return 0
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("SelectedHourPicker changed: \(HoursPerDayPickerArray[row])")
        SelectedHoursPickerValue = HoursPerDayPickerArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: HoursPerDayPickerArray[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
    

    
    /* MARK: TableView Delegates
    ###############################################################################################################*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.indexPathForSelectedRow
        self.SelectedTimeLineData = self.timelineDataArray[indexPath.row]
        self.SelectedTimelineDatoRowIndex = indexPath.row
        createActionSheetAlert(selectedElement: SelectedTimeLineData)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (timelineDataArray?.count)! > 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell") as? TimelineCell {
                cell.CofigureCell(timeline: timelineDataArray![indexPath.row])
                
                cell.backgroundColor = UIColor.clear
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineDataArray!.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            TimelineData.DeleteTimelineData(timelineDataArray[indexPath.row], context: appDel.managedObjectContext)
            timelineDataArray.remove(at: indexPath.row)
            TimeLineDataTableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    
    /*  MARK: - Navigation Prepare For Segue    ##############################################################################################################*/
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? EditTimelinePopUpVC, let popPC = dest.popoverPresentationController{
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
        self.selectedStartDate = sender.date as NSDate
        print("StartDatePicker changed: \(sender.date)")
    }
    @IBAction func EndTimePickerChanged(sender: UIDatePicker) {
        self.SelectedEndDate = sender.date as NSDate
        print("EndDatePicker changed: \(sender.date)")
    }
    @IBAction func saveTimelineDataAction(sender: AnyObject) {
        let allData:[TimelineData] = TimelineData.FetchData(appDel.managedObjectContext)!
        if  Int(SelectedHoursPickerValue)! <= allData.count {
            let alert = UIAlertController(title: "Alert_WrongUserInput_Title".localized, message: "TimelineVC_AlertHourNumberColliding_Message".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        var cnt:Int = allData.count
        cnt-=1
        if allData.count > 0{
            let result = TimelineData.collidesWithExistingTimelineData(cnt, allData: allData , cStartDate: selectedStartDate as Date, cEndDate: SelectedEndDate as Date)
            if  result == CollidingTime.collidesWithExistingTime{
                let alert = UIAlertController(title: "Alert_WrongUserInput_Title".localized, message: "TimelineVC_AlertTimePeriodColliding_Message".localized , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }else if result == CollidingTime.startTimeIsBiggerThanEndTime{
                let alert = UIAlertController(title: "Alert_WrongUserInput_Title".localized, message: "TimelineVC_AlertStartTimeSmallerThanEndTime_Message".localized , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        }
        // Save TimelineData
        TimelineData.SaveTimelineData(self.CastStringToNSNumber(strNumber: SelectedHoursPickerValue)!, starttime: selectedStartDate as Date, endtime: SelectedEndDate as Date, context: appDel.managedObjectContext)
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
            title: "ActionSheet_ElementAction_Title".localized, message: "TimelineVC_ActionSheetTimeTableActions_Message".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Alert_Action_Edit".localized + " \(selectedElement.hour!)", style: .default, handler: { (UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "ShowEditTimelinePopOver", sender:  selectedElement)
        }))
        let plans = Planer.fetchNotEmptyPlanerElementsWithHour(hourSortnumber: selectedElement.hour!, context: appDel.managedObjectContext)!
        print(plans.count)
        if plans.count == 0{
            alert.addAction(UIAlertAction(title: "Alert_Action_Delete".localized + " \(selectedElement.hour!)", style: .destructive, handler: {  (action: UIAlertAction)-> Void in
                TimelineData.DeleteTimelineData(selectedElement, context: self.appDel.managedObjectContext)
                self.ReloadTableView()
            }))
        }
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .cancel, handler: { (UIAlertAction) -> Void in }))
        present(alert, animated: true, completion: nil)
    }
    
    
    /**Sets the number of Elemets in the HoursPerDayArray
     to the int value of HoursPerDay property
     - Resets the element count to 0 before appending new elements*/
    private func SetHoursPerDayPickerElementCount(){
        //Fetch the HoursPerDay from Core Data
        HoursPerDayDataArray = HoursPerDayData.FetchData(context: appDel.managedObjectContext)
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
