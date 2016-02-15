
import UIKit
import CoreData

class EditTeacherVC: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate  {
    /*@IBOutlet
    ###############################################################################################################*/
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var txtTeacherName: UITextField!
    @IBOutlet var GenderSelector: UISegmentedControl!
    /*Members
    ###############################################################################################################*/
     //AppDelegate Object
    let appDel = UIApplication.sharedApplication().delegate  as! AppDelegate
    
    //Teacher Array for CoraData fetches
    var myTeacherToEdit:Teacher?
    
    /*ViewController Delegate
    ##############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTeacherName.delegate = self
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        txtTeacherName.text = myTeacherToEdit!.name
        if myTeacherToEdit!.iamgeName! == "MaleIcon" {
            GenderSelector.selectedSegmentIndex = 0
        }
        else{
            GenderSelector.selectedSegmentIndex = 1
        }
    }
    //Textfield Delegate
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        btnSaveTeacherAction()
        return true
    }

    
    /*Prepare For Segue    ##############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue from: \(segue.sourceViewController.title) to: \(segue.destinationViewController.title)")
        if let dest = segue.destinationViewController as? TeacherTableVC{
            dest.unwindToTeacherTableView(segue)
        }
    }

    
 /*Helper Methods    ###############################################################################################################*/
   @IBAction func btnSaveTeacherAction() {
        myTeacherToEdit?.name = txtTeacherName.text!
        if GenderSelector.selectedSegmentIndex == 0 {
            myTeacherToEdit!.iamgeName = "MaleIcon"
        }
        else{
             myTeacherToEdit!.iamgeName = "FemaleIcon"
        }
        Teacher.EditTeacher(myTeacherToEdit!, context: appDel.managedObjectContext)
        self.performSegueWithIdentifier("unwindToTeacherTableView", sender: nil)
    }
}
