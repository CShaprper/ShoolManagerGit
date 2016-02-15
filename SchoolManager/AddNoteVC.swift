//
//  AddNoteVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 16.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit
import EventKit
import iAd

class AddNoteVC: UIViewController,UIPopoverPresentationControllerDelegate, UITextViewDelegate, ADBannerViewDelegate {
    
    /*MARK: Outlet / Member    ###############################################################################################################*/
    
    @IBOutlet var notePad: UIImageView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var reminderDateLabel: UILabel!
    @IBOutlet var SubjectImageView: UIImageView!
    @IBOutlet var subjectColorView: UIView!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var notesTextView: UITextView!
    var selectedDate:NSDate!;
    var selectedSubject:Subject?
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.adDefaults.boolForKey("purchased"){
            loadAds()
        }
        notesTextView.backgroundColor = UIColor.clearColor()
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
        UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(10), shadowRadius: CGFloat(3), layer: self.notePad.layer)
        notesTextView.delegate = self
        notesTextView.textColor = UIColor.grayColor()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)        
        setUI()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
    
    
    
    /*MARK: TextView Delegates
    ###############################################################################################################*/
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.grayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "AddNotePlaceholderText".localized
            textView.textColor = UIColor.grayColor()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? SelectSubjectNoteVC,
            popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
        if let dest = segue.destinationViewController as? SelectReminderDateVC,
            popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
    }
    @IBAction func unwindToAddNote(segue:UIStoryboardSegue){
        if selectedSubject != nil{
            self.subjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: selectedSubject!.color!)
            self.subjectColorView.layer.cornerRadius = 5
            self.subjectLabel.text = selectedSubject!.subject!
            self.SubjectImageView.image = UIImage(named: selectedSubject!.imageName!)
        }
        if selectedDate != nil{
            reminderDateLabel.text = NSDate.dateTimeFormatter(selectedDate)
        }
    }
    
    /*MARK: Actions    ###############################################################################################################*/
    @IBAction func handleTap(){
        
    }
    @IBAction func saveNoteAction() {
        if notesTextView.text == "" {
            createOKOnlyAlert("Alert_MissingData_Title".localized, message: "AddNoteAddNoteText".localized)
            return
        }
        if selectedDate != nil{
            if selectedDate.compare(NSDate()) == NSComparisonResult.OrderedAscending{
                createOKOnlyAlert("Alert_WrongUserInput_Title".localized, message: "Alert_WrongReminderDate_Message".localized)
                return
            }
        }
        if selectedSubject == nil{
            createOKOnlyAlert("Alert_MissingData_Title".localized, message: "PlanerSetup_MissingSubject_Message".localized)
            return
        }
        let uid = randomAlphaNumericString(10)
        print(uid)
        Note.SaveNote(selectedDate, strUUID: uid, strNote: self.notesTextView.text, subject: selectedSubject!, context: appDel.managedObjectContext)
        
        if selectedDate != nil{
            NotificationManager.createSingleNotification(selectedDate, alertBody: notesTextView.text, category: appDel.firstCategory, objectID: uid)
        }
        self.performSegueWithIdentifier("unwindToNotes", sender: nil)
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func setUISubject(subject:Subject){
        selectedSubject = subject
    }
    func setUI(){
        if selectedSubject != nil{
            subjectLabel.text = selectedSubject!.subject!
            subjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: selectedSubject!.color!)
        }
    }
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    func requestCalendarAuthorization(){
        switch EKEventStore.authorizationStatusForEntityType(.Reminder){
        case .Authorized:
            break
        case .Denied:
            createAlert("Need Calendar Access", message: "Calendar access is needed to create reminder.")
            break
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Reminder, completion: { (granted, error) -> Void in
                if granted{
                    //
                }else{
                    self.createAlert("Need Calendar Access", message: "Calendar access is needed to create reminder.")
                }
            })
            break
        default:
            break
        }
    }
    
    func requestReminderAuthorization(){
        switch EKEventStore.authorizationStatusForEntityType(.Event){
        case .Authorized:
            self.createReminder(self.eventStore, title: "School Manager", note: self.notesTextView.text, reminderdate: self.selectedDate)
            break
        case .Denied:
            createAlert("Need Reminder Access", message: "Reminder access is needed to create reminder.")
            break
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Reminder, completion: { (granted, error) -> Void in
                if granted{
                    self.createReminder(self.eventStore, title: "School Manager", note: self.notesTextView.text, reminderdate: self.selectedDate)
                }else{
                    self.createAlert("Need Reminder Access", message: "Reminder access is needed to create reminder.")
                }
            })
            break
        default:
            break
        }
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
    
    func createAlert(title:String, message:String){
        //Create an alert to get acess to calendar
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Alert_GotToSettings".localized, style: .Default, handler: { (UIAlertAction) -> Void in
            let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(openSettingsUrl!)
        }))
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Cancel, handler: { (UIAlertAction) -> Void in }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createEvent(eventStore:EKEventStore, title:String, note:String, startdate:NSDate, enddate:NSDate){
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.notes = note
        event.startDate = startdate
        event.endDate = enddate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do{
            try eventStore.saveEvent(event, span: .ThisEvent)
        }catch let error as NSError{
            let alert = UIAlertController(title: "Alert_Error_Title".localized, message: error.localizedDescription, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in  }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func createReminder(eventStore:EKEventStore, title:String, note:String, reminderdate:NSDate){
        let event = EKReminder(eventStore: eventStore)
        event.title = title
        event.notes = note
        let alarm = EKAlarm(absoluteDate: reminderdate)
        event.addAlarm(alarm)
        event.calendar = eventStore.defaultCalendarForNewReminders()
        do{
            try eventStore.saveReminder(event, commit: true)
        }catch let error as NSError{
            let alert = UIAlertController(title: "Alert_Error_Title".localized, message: error.localizedDescription, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in  }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}
