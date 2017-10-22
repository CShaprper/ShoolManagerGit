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
        datePicker.minimumDate = selectedDate! as Date
        datePicker.date = selectedDate as Date
        datePicker.setValue(UIColor.white, forKey: "textColor")
        UIDesignHelper.ShadowMaker(shadowColor: UIColor.black, shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*MARK: DatePicker Delegates    ###############################################################################################################*/
    @IBAction func DatePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date as NSDate
    }

 
    /*MARK: Navigation    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? AddNoteVC{
        dest.selectedDate = selectedDate
            dest.unwindToAddNote(segue: segue)
        }
    }

    @IBAction func saveDateAction() {        
        if selectedDate.compare(NSDate() as Date)  == ComparisonResult.orderedAscending{
            createOKOnlyAlert(title: "Alert_WrongUserInput_Title".localized, message: "Alert_WrongReminderDate_Message".localized)
            return
        }        
        self.performSegue(withIdentifier: "unwindToAddNote", sender: nil)
    }
  
    
    /**
     **Creates an OK only alert**
     - Parameters:
     - title: **String:**   Title of alert
     - message: **String:**   Body of alert
     */
    func createOKOnlyAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in  }))
        present(alert, animated: true, completion: nil)
    }
}
