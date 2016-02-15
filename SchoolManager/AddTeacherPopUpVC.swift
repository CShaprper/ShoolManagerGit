
import UIKit
import CoreData

class AddTeacherererVC: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    /*@IBOutlet & Menbers
    ###############################################################################################################*/
    @IBOutlet var txtTeacherName: UITextField!
    @IBOutlet var genderSelector: UISegmentedControl!
    
    //AppDelegate instance
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /*ViewController Delegates
    ##############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTeacherName.delegate = self
        popoverPresentationController?.delegate = self
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(15), layer: self.view.layer)
        self.view.layer.borderWidth = 5
        self.view.layer.borderColor = UIColor.clearColor().CGColor  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
    }
    //Textfield Delegate
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        txtTeacherName.resignFirstResponder()
        return true;
    }
    
    
    /*Prepare For Segue    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!{
        case "unwindToTeacherTableView":
            let dest = segue.destinationViewController  as! TeacherTableVC
            dest.unwindToTeacherTableView(segue)
            break
        default:
            break
        }
    }
    
    
    /*Helper Methods ###############################################################################################################*/
    @IBAction func btnSaveTeacherAction() {
        var imageName: String!
        if genderSelector.selectedSegmentIndex == 0
        { imageName = "MaleIcon"}else{ imageName = "FemaleIcon"}
        if txtTeacherName.text! != ""{
            Teacher.SaveTeacher(txtTeacherName.text!, imageName: imageName, context: appDel.managedObjectContext)
        }
        self.performSegueWithIdentifier("unwindToTeacherTableView", sender: nil)
    }
    @IBAction func btnCancelAction() {
        self.performSegueWithIdentifier("unwindToTeacherTableView", sender: nil)
    }
   
}
