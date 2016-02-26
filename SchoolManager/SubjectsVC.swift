
import UIKit
import iAd

class SubjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, ADBannerViewDelegate, ColorPickerDelegate {
    /*MARK: Outlet / Member    ###############################################################################################################*/
    @IBOutlet var SubjectImageButton: UIButton!
    @IBOutlet var ColorButton: UIButton!
    @IBOutlet var SubjectTextfield: UITextField!
    @IBOutlet var subjectsTableView: UITableView!
    @IBOutlet var SaveButton: UIButton!
    @IBOutlet var BackgroundImageView: UIImageView!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedColor:UIColor!
    var selectedHexColor:String?
    var selectedTeacher:Teacher?
    var selectedImageName:String?
    let wTransition = WipeTransition()
    var subjectsCollection:[Subject]!
    var selectedSubject:Subject!
    var isEditAction:Bool = false
    var layers:[CALayer] = [CALayer]()
    
    /*MARK: ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.boolForKey("com.petersypek.SchoolManager"){
            loadAds()
        }
        ColorButton.layer.cornerRadius = 5
        popoverPresentationController?.delegate = self
        self.SubjectTextfield.delegate = self
        
        self.layers.append(SubjectImageButton.layer)
        self.layers.append(ColorButton.layer)
        self.layers.append(SubjectTextfield.layer)
        self.layers.append(SaveButton.layer)
        selectedHexColor = ""
        UIDesignHelper.ShadowMakerMultipleLayers(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(15), layers: layers)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subjectsTableView.backgroundColor  = UIColor.clearColor()
        reloadSubjectCollection()
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
    
    /*MARK: - Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? ColorPickerViewController,
            popPC = dest.popoverPresentationController{
                dest.colorPickerDelegate = self
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? SubjectIconPicker,
            popPC = dest.popoverPresentationController{
                //dest.colorPickerDelegate = self
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? SettingsMenueVC{
            dest.transitioningDelegate = wTransition
        }
    }
    @IBAction func unwindToSubjects(segue:UIStoryboardSegue){
        if let _ = segue.sourceViewController as? SubjectIconPicker{
            SubjectImageButton.setImage(UIImage(named: selectedImageName!), forState: .Normal)
        }
    }
    
    /*MARK: ColorPicker Delegate    ###############################################################################################################*/
    // MARK: Color picker delegate functions
    // called by color picker after color selected.
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        // update color value within class variable
        self.selectedColor = selectedUIColor
        self.selectedHexColor = selectedHexColor
        
        // set preview background to selected color
        self.ColorButton.backgroundColor = selectedUIColor
    }
    /*MARK: TableViewDelegate    ###############################################################################################################*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell") as? SubjectCell{
            cell.configureCell(subjectsCollection[indexPath.row])
            return cell
        }
        else{
            return SubjectCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = subjectsTableView.indexPathForSelectedRow
        self.selectedSubject = self.subjectsCollection![indexPath.row]
        createActionSheetAlert(selectedSubject)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsCollection.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        Subject.DeleteSubject(subjectsCollection[indexPath.row], context: appDel.managedObjectContext)
        subjectsCollection.removeAtIndex(indexPath.row)
        subjectsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    /*@IBActions    ###############################################################################################################*/
    @IBAction func SubjectImageButtonAction() {
    }
    @IBAction func ColorButtonAction() {
        self.performSegueWithIdentifier("ShowColorPicker", sender: nil)
    }
    @IBAction func SaveButtonAction(sender: AnyObject) {
        if SubjectTextfield.text != nil && SubjectTextfield.text == ""{
            let noSubjectAlert = UIAlertController(
                title: "Alert_MissingData_Title".localized,
                message: "Alert_MissingSubject_Message".localized,
                preferredStyle: .Alert
            )
            noSubjectAlert.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: nil)
            )
            presentViewController(noSubjectAlert, animated: true, completion: nil)
            return
        }
        if selectedHexColor! == ""{
            let noColorAlert = UIAlertController(
                title: "Alert_MissingData_Title".localized,
                message: "Alert_MissingColor_Message".localized,
                preferredStyle: .Alert
            )
            noColorAlert.addAction(UIAlertAction(title: "OK",
                style: .Default,
                handler: nil)
            )
            presentViewController(noColorAlert, animated: true, completion: nil)
            return
        }
        if selectedImageName == nil || selectedImageName == ""{
            selectedImageName = "placeholder"
        }
        if isEditAction{
            selectedSubject.subject = SubjectTextfield.text
            selectedSubject.color = selectedHexColor
            selectedSubject.imageName = selectedImageName
            Subject.EditTeacher(selectedSubject, context: appDel.managedObjectContext)
            isEditAction = false
            reloadSubjectCollection()
        }else{
            Subject.SaveSubject(SubjectTextfield.text!, hexColor: selectedHexColor!, imageName: selectedImageName!, context: appDel.managedObjectContext)
            reloadSubjectCollection()
        }
        resetUI()
        textFieldShouldReturn(SubjectTextfield)
    }
    
    /*Helper Functions    ###############################################################################################################*/
    /**
    **Reloads subject collection and refreshes TableView**
    */
    private func reloadSubjectCollection(){
        subjectsCollection = Subject.FetchData(appDel.managedObjectContext)
        self.subjectsTableView.reloadData()
        self.subjectsTableView.AnimateTable()
    }
    
    func resetUI(){
        selectedSubject = nil
        SubjectImageButton.setImage(UIImage(named: "placeholder-add"), forState: .Normal)
        ColorButton.setImage(UIImage(named: "placeholder-add"), forState: .Normal)
        ColorButton.backgroundColor = UIColor.clearColor()
        SubjectTextfield.text = ""
        selectedHexColor = ""        
    }
    
    // show color picker from UIButton
    private func showColorPicker(){
        
        // initialise color picker view controller
        let colorPickerVc = storyboard?.instantiateViewControllerWithIdentifier("ColorPicker") as! ColorPickerViewController
        
        // set modal presentation style
        colorPickerVc.modalPresentationStyle = .Popover
        
        // set max. size
        colorPickerVc.preferredContentSize = CGSizeMake(265, 400)
        
        // set color picker deleagate to current view controller
        // must write delegate method to handle selected color
        colorPickerVc.colorPickerDelegate = self
        
        // show popover
        if let popoverController = colorPickerVc.popoverPresentationController {
            
            // set source view
            popoverController.sourceView = self.ColorButton
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.Up
            
            // set popover delegate self
            popoverController.delegate = self
        }
        
        //show color popover
        presentViewController(colorPickerVc, animated: true, completion: nil)
    }
    func createActionSheetAlert(selectedElement:Subject){
        let alert = UIAlertController(
            title: "ActionSheet_ElementAction_Title".localized, message: "SubjectsVC_ActionSheetTimeTableActions_Message".localized, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Alert_Action_Edit".localized + " \(selectedElement.subject!)", style: .Default, handler: { (UIAlertAction) -> Void in
            let img = UIImage(named: selectedElement.imageName!)
            self.SubjectImageButton.setImage(img, forState: .Normal)
            self.SubjectTextfield.text = selectedElement.subject
            let col:UIColor = ColorHelper.convertHexToUIColor(hexColor: selectedElement.color!)
            self.selectedHexColor = selectedElement.color
            self.selectedImageName = selectedElement.imageName
            self.ColorButton.backgroundColor = col
            self.isEditAction = true
        }))
        let plans = Planer.fetchPlanerObjectsWithSubjectPredicate(selectedElement.subject!, context: self.appDel.managedObjectContext)!
        if plans.count == 0{
            alert.addAction(UIAlertAction(title: "Alert_Action_Delete".localized + " \(selectedElement.subject!)", style: .Destructive, handler: {  (action: UIAlertAction)-> Void in
                Subject.DeleteSubject(selectedElement, context: self.appDel.managedObjectContext)
                self.textFieldShouldReturn(self.SubjectTextfield)
                self.reloadSubjectCollection()
            }))
        }
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Cancel, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
