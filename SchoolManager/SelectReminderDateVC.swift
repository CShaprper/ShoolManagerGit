//
//  SelectReminderDateVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 01.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class SelectReminderDateVC: UIViewController {
    /*MARK: Member / Outlets
    ###############################################################################################################*/
    var selectedDate:NSDate!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var saveButton: UIButton!
    
    /*MARK: ViewController Lifecycle    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = NSDate()
        datePicker.minimumDate = selectedDate
        datePicker.date = selectedDate
        datePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*MARK: DatePicker Delegates    ###############################################################################################################*/
    @IBAction func DatePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date
    }

 
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? AddNoteVC{
        dest.selectedDate = selectedDate
        dest.unwindToAddNote(segue)
        }
    }

    @IBAction func saveDateAction() {        
        if selectedDate.compare(NSDate())  == NSComparisonResult.OrderedAscending{
            createOKOnlyAlert("Alert_WrongUserInput_Title".localized, message: "Alert_WrongReminderDate_Message".localized)
            return
        }        
        self.performSegueWithIdentifier("unwindToAddNote", sender: nil)
    }
  
    
    /**
     **Creates an OK only alert**
     - Parameters:
     - title: **String:**   Title of alert
     - message: **String:**   Body of alert
     */
    func createOKOnlyAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in  }))
        presentViewController(alert, animated: true, completion: nil)
    }
}
