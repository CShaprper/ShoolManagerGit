
import UIKit
import iAd

class SubjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, ADBannerViewDelegate { 
    
    /*MARK: Outlet / Member    ###############################################################################################################*/
    @IBOutlet var SubjectImageButton: UIButton!
    @IBOutlet var ColorButton: UIButton!
    @IBOutlet var SubjectTextfield: UITextField!
    @IBOutlet var subjectsTableView: UITableView!
    @IBOutlet var SaveButton: UIButton!
    @IBOutlet var BackgroundImageView: UIImageView!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
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
        if !appDel.userDefaults.bool(forKey: appDel.removeAdsIdentifier){
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
        UIDesignHelper.ShadowMakerMultipleLayers(shadowColor: UIColor.black, shadowOffset: CGFloat(15), shadowRadius: CGFloat(15), layers: layers)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subjectsTableView.backgroundColor  = UIColor.clear
        reloadSubjectCollection()
    }
/*TODO: Overwork
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        self.appDel.adBannerView.isHidden = true
        view.addSubview(self.appDel.adBannerView)
    }
    func bannerView(_ banner: ADBannerView, didFailToReceiveAdWithError error: Error) {
        self.appDel.adBannerView.isHidden = true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDel.adBannerView.isHidden = false
    }
    
    /*MARK: - Navigation    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /* TODO: New ColorPicker needed
        if let dest = segue.destinationViewController as? ColorPickerViewController,
            let popPC = dest.popoverPresentationController{
                dest.colorPickerDelegate = self
                popPC.delegate = self
        }*/
        if let dest = segue.destination as? SubjectIconPicker,
            let popPC = dest.popoverPresentationController{
                //dest.colorPickerDelegate = self
                popPC.delegate = self
        }
        if let dest = segue.destination as? SettingsMenueVC{
            dest.transitioningDelegate = wTransition
        }
    }
    @IBAction func unwindToSubjects(segue:UIStoryboardSegue){
        if let _ = segue.source as? SubjectIconPicker{
            SubjectImageButton.setImage(UIImage(named: selectedImageName!), for: .normal)
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell") as? SubjectCell{
            cell.configureCell(sub: subjectsCollection[indexPath.row])
            return cell
        }
        else{
            return SubjectCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = subjectsTableView.indexPathForSelectedRow
        self.selectedSubject = self.subjectsCollection![indexPath.row]
        createActionSheetAlert(selectedElement: selectedSubject)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsCollection.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        Subject.DeleteSubject(subjectsCollection[indexPath.row], context: appDel.managedObjectContext)
        subjectsCollection.remove(at: indexPath.row)
        subjectsTableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    /*@IBActions    ###############################################################################################################*/
    @IBAction func SubjectImageButtonAction() {
    }
    @IBAction func ColorButtonAction() {
        self.performSegue(withIdentifier: "ShowColorPicker", sender: nil)
    }
    @IBAction func SaveButtonAction(sender: AnyObject) {
        if SubjectTextfield.text != nil && SubjectTextfield.text == ""{
            let noSubjectAlert = UIAlertController(
                title: "Alert_MissingData_Title".localized,
                message: "Alert_MissingSubject_Message".localized,
                preferredStyle: .alert
            )
            noSubjectAlert.addAction(UIAlertAction(title: "OK",
                                                   style: .default,
                handler: nil)
            )
            present(noSubjectAlert, animated: true, completion: nil)
            return
        }
        if selectedHexColor! == ""{
            let noColorAlert = UIAlertController(
                title: "Alert_MissingData_Title".localized,
                message: "Alert_MissingColor_Message".localized,
                preferredStyle: .alert
            )
            noColorAlert.addAction(UIAlertAction(title: "OK",
                                                 style: .default,
                handler: nil)
            )
            present(noColorAlert, animated: true, completion: nil)
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
        SubjectImageButton.setImage(UIImage(named: "placeholder-add"), for: .normal)
        ColorButton.setImage(UIImage(named: "placeholder-add"), for: .normal)
        ColorButton.backgroundColor = UIColor.clear
        SubjectTextfield.text = ""
        selectedHexColor = ""        
    }
    
    // show color picker from UIButton
    private func showColorPicker(){
/* TODO: New Color Picker needed
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
 */
    }
    func createActionSheetAlert(selectedElement:Subject){
        let alert = UIAlertController(
            title: "ActionSheet_ElementAction_Title".localized, message: "SubjectsVC_ActionSheetTimeTableActions_Message".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Alert_Action_Edit".localized + " \(selectedElement.subject!)", style: .default, handler: { (UIAlertAction) -> Void in
            let img = UIImage(named: selectedElement.imageName!)
            self.SubjectImageButton.setImage(img, for: .normal)
            self.SubjectTextfield.text = selectedElement.subject
            let col:UIColor = ColorHelper.convertHexToUIColor(hexColor: selectedElement.color!)
            self.selectedHexColor = selectedElement.color
            self.selectedImageName = selectedElement.imageName
            self.ColorButton.backgroundColor = col
            self.isEditAction = true
        }))
        let plans = Planer.fetchPlanerObjectsWithSubjectPredicate(subject: selectedElement.subject!, context: self.appDel.managedObjectContext)!
        if plans.count == 0{
            alert.addAction(UIAlertAction(title: "Alert_Action_Delete".localized + " \(selectedElement.subject!)", style: .destructive, handler: {  (action: UIAlertAction)-> Void in
                Subject.DeleteSubject(selectedElement, context: self.appDel.managedObjectContext)
                self.textFieldShouldReturn(self.SubjectTextfield) //layer.shadowOffset = CGSize(shadowOffset, shadowOffset/2); //TODO: Overwork
                self.reloadSubjectCollection()
            }))
        }
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .cancel, handler: { (UIAlertAction) -> Void in }))
        present(alert, animated: true, completion: nil)
    }
    
}
