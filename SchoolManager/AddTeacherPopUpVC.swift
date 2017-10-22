
import UIKit
import CoreData

class AddTeacherererVC: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    /*@IBOutlet & Menbers
    ###############################################################################################################*/
    @IBOutlet var txtTeacherName: UITextField!
    @IBOutlet var genderSelector: UISegmentedControl!
    
    //AppDelegate instance
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    /*ViewController Delegates
    ##############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTeacherName.delegate = self
        popoverPresentationController?.delegate = self
        UIDesignHelper.ShadowMaker(UIColor.black, shadowOffset: CGFloat(15), shadowRadius: CGFloat(15), layer: self.view.layer)
        self.view.layer.borderWidth = 5
        self.view.layer.borderColor = UIColor.clear.cgColor  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.defaultCenter().postNotificationName("load", object: nil)
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
            let dest = segue.destination  as! TeacherTableVC
            dest.unwindToTeacherTableView(segue: segue)
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
        self.performSegue(withIdentifier: "unwindToTeacherTableView", sender: nil)
    }
    @IBAction func btnCancelAction() {
        self.performSegue(withIdentifier: "unwindToTeacherTableView", sender: nil)
    }
   
}
