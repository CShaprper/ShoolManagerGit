//
//  EditTimelineVCViewController.swift
//  SchoolManager
//
//  Created by Peter Sypek on 23.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class EditTimelinePopUpVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate {
    /*Outlets    ###############################################################################################################*/
    @IBOutlet var StartDatePicker: UIDatePicker!
    @IBOutlet var EndDatePicker: UIDatePicker!
    @IBOutlet var HoursPicker: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    
    /*Members    ###############################################################################################################*/
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var myTimeLineDataToEdit:TimelineData!
    var myHoursPickerSource:[String]!
    var SelectedHoursPickerValue:String = "1"
    var SelectedPickerRowIndex:Int!
    private var canDeleteTimelineData:Bool = false
    
    /*View Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        HoursPicker.delegate = self
        HoursPicker.dataSource = self
        popoverPresentationController?.delegate = self
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.StartDatePicker.date = self.myTimeLineDataToEdit.startTime!
        self.EndDatePicker.date = self.myTimeLineDataToEdit.endTime!
        self.SelectedHoursPickerValue = self.myTimeLineDataToEdit.hour!.stringValue
        HoursPicker.selectRow(self.SelectedPickerRowIndex, inComponent: 0, animated: animated)
        canDeleteTimelineData = true
        
        EndDatePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
        StartDatePicker.setValue(UIColor.whiteColor(), forKey: "textColor")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*MARK: PickerView Delegates    ###############################################################################################################*/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myHoursPickerSource[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myHoursPickerSource.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("SelectedHourPicker tp Edit changed: \(myHoursPickerSource[row])")
        SelectedHoursPickerValue = myHoursPickerSource[row]
        myTimeLineDataToEdit.hour = self.CastStringToNSNumber(SelectedHoursPickerValue)
        canDeleteTimelineData = false
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: myHoursPickerSource[row], attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
    /*MARK: DatePickerView Actions    ###############################################################################################################*/
    @IBAction func StartTimeDatePickerValueChanged(sender: UIDatePicker) {
        myTimeLineDataToEdit.startTime = sender.date
        canDeleteTimelineData = false
    }
    @IBAction func EndTimeDatePickerValueChanged(sender: UIDatePicker) {
        myTimeLineDataToEdit.endTime = sender.date
        canDeleteTimelineData = false
    }
    
    
    
    /*MARK: - Navigation      ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!{
        case "unwindToNewTimeline":
            let dest = segue.destinationViewController as! TimelineVC
            dest.unwindToNewTimeline(segue)
            break
        case "unwindToNewTimelineRemove":
            let dest = segue.destinationViewController as! TimelineVC
            dest.unwindToNewTimeline(segue)
            break
        default:
            break
        }
    }    
    
    
    /*@IBActions    ###############################################################################################################*/
    /**
    **Saves the Edited TimelineData from UI**
    */
    @IBAction func SaveEditedTimeLineData() {
        TimelineData.EditTimeLineData(myTimeLineDataToEdit, context: appDel.managedObjectContext)
    }    
}
