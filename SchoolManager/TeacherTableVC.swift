
import UIKit
import CoreData
import iAd

class TeacherTableVC: UIViewController,UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, ADBannerViewDelegate {
    /*@IBOutlet    ###############################################################################################################*/
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var BackgroundImageView: UIImageView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var txtTeacherName: UITextField!
    @IBOutlet var genderSelector: UISegmentedControl!
    
    /*Members    ###############################################################################################################*/
    var myTeachers:[NSManagedObject]? = nil
    var selectedTeacher:Teacher!
    let appDel = UIApplication.sharedApplication().delegate  as! AppDelegate
    private var iiEditAction:Bool = false
    
    
    
    /*ViewController Delegates    ##############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.boolForKey("com.petersypek.SchoolManager"){
            loadAds()
        }
        tableview.backgroundColor  = UIColor.clearColor()
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.txtTeacherName.layer)
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.genderSelector.layer)
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        myTeachers = Teacher.FetchData(appDel.managedObjectContext)
        self.tableview.reloadData()
        self.tableview.AnimateTable()
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? EditTeacherVC, popPC = dest.popoverPresentationController{
            dest.myTeacherToEdit = self.selectedTeacher
            popPC.popoverLayoutMargins = UIEdgeInsetsMake(60, 30, 30, 30)
            popPC.delegate = self
        }
    }
    @IBAction func unwindToTeacherTableView(segue:UIStoryboardSegue){
        ReloadTableView()
    }
    
    
    /*TableView Delegate    ##############################################################################################################*/
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableview.indexPathForSelectedRow
        self.selectedTeacher = self.myTeachers![indexPath.row] as! Teacher
        createActionSheetAlert(self.selectedTeacher)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("TeacherCell") as? TeacherCell{
            cell.CofigureCell(myTeachers![indexPath.row] as! Teacher)
            return cell
        }
        else{
            return TeacherCell()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTeachers!.count
    }
    
    /*MARK: @IBActions    ###############################################################################################################*/
    @IBAction func SaveButtonAction() {
        var tisimageName: String!
        if genderSelector.selectedSegmentIndex == 0 {
            tisimageName = "MaleIcon"
        }
        else{
            tisimageName = "FemaleIcon"
        }
        //        if genderSelector.selectedSegmentIndex == 0
        //        { imageName = "MaleIcon"}else{ imageName = "FelameIcon" }
        if txtTeacherName.text! != ""{
            Teacher.SaveTeacher(txtTeacherName.text!, imageName: tisimageName, context: appDel.managedObjectContext)
        }
        textFieldShouldReturn(txtTeacherName)
        ReloadTableView()
    }
    
    /*Helper Methods    ##############################################################################################################*/
    func ReloadTableView(){
        myTeachers = Teacher.FetchData(appDel.managedObjectContext)
        self.tableview.reloadData()
        self.tableview.AnimateTable()
    }
    
    func createActionSheetAlert(selectedElement:Teacher){
        let alert = UIAlertController(
            title: "ActionSheet_ElementAction_Title".localized, message: "TeacherTable_TeacherActionSheet_Message".localized, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Alert_Action_Edit".localized, style: .Default, handler: { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier("ShowEditTeacherPage", sender: selectedElement)
        }))
        let plans = Planer.fetchPlanerObjectsWithTeachernamePredicate(selectedElement.name!, context: appDel.managedObjectContext)!
        if plans.count == 0{
            alert.addAction(UIAlertAction(title: "Alert_Action_Delete".localized, style: .Destructive, handler: {  (action: UIAlertAction)-> Void in
                Teacher.DeleteTeacher(selectedElement, context: self.appDel.managedObjectContext)
                self.ReloadTableView()
            }))
        }
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Cancel, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
