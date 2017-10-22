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
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.bool(forKey: appDel.removeAdsIdentifier){
            loadAds()
        }
        notesTextView.backgroundColor = UIColor.clear
        UIDesignHelper.ShadowMaker(shadowColor: UIColor.black, shadowOffset: CGFloat(15), shadowRadius: CGFloat(3), layer: self.saveButton.layer)
        UIDesignHelper.ShadowMaker(shadowColor: UIColor.black, shadowOffset: CGFloat(10), shadowRadius: CGFloat(3), layer: self.notePad.layer)
        notesTextView.delegate = self
        notesTextView.textColor = UIColor.gray
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        setUI()
    }
/* TODO: Overwork
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
 */
    
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
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        self.appDel.adBannerView.isHidden = true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDel.adBannerView.isHidden = false
    }
    
    
    
    /*MARK: TextView Delegates
    ###############################################################################################################*/
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "AddNotePlaceholderText".localized
            textView.textColor = UIColor.gray
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*MARK: Navigation    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? SelectSubjectNoteVC,
            let popPC = dest.popoverPresentationController{
                popPC.delegate = self
        }
        if let dest = segue.destination as? SelectReminderDateVC,
            let popPC = dest.popoverPresentationController{
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
            reminderDateLabel.text = NSDate.dateTimeFormatter(date: selectedDate)
        }
    }
    
    /*MARK: Actions    ###############################################################################################################*/
    @IBAction func handleTap(){
        
    }
    @IBAction func saveNoteAction() {
        if notesTextView.text == "" {
            createOKOnlyAlert(title: "Alert_MissingData_Title".localized, message: "AddNoteAddNoteText".localized)
            return
        }
        if selectedDate != nil{
            if selectedDate.compare(NSDate() as Date) == ComparisonResult.orderedAscending{
                createOKOnlyAlert(title: "Alert_WrongUserInput_Title".localized, message: "Alert_WrongReminderDate_Message".localized)
                return
            }
        }
        if selectedSubject == nil{
            createOKOnlyAlert(title: "Alert_MissingData_Title".localized, message: "PlanerSetup_MissingSubject_Message".localized)
            return
        }
        let uid = randomAlphaNumericString(length: 10)
        print(uid)
        Note.SaveNote(dueDate: selectedDate, strUUID: uid, strNote: self.notesTextView.text, subject: selectedSubject!, context: appDel.managedObjectContext)
        
        if selectedDate != nil{
            NotificationManager.createSingleNotification(fireDate: selectedDate, alertBody: notesTextView.text, category: appDel.firstCategory, objectID: uid)
        }
        self.performSegue(withIdentifier: "unwindToNotes", sender: nil)
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
        let randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            //let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)] //TODO: Overwork needed
           // randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    func requestCalendarAuthorization(){
        switch EKEventStore.authorizationStatus(for: .reminder){
        case .authorized:
            break
        case .denied:
            createAlert(title: "Need Calendar Access", message: "Calendar access is needed to create reminder.")
            break
        case .notDetermined:
            eventStore.requestAccess(to: .reminder, completion: { (granted, error) -> Void in
                if granted{
                    //
                }else{
                    self.createAlert(title: "Need Calendar Access", message: "Calendar access is needed to create reminder.")
                }
            })
            break
        default:
            break
        }
    }
    
    func requestReminderAuthorization(){
        switch EKEventStore.authorizationStatus(for: .event){
        case .authorized:
            self.createReminder(eventStore: self.eventStore, title: "School Manager", note: self.notesTextView.text, reminderdate: self.selectedDate)
            break
        case .denied:
            createAlert(title: "Need Reminder Access", message: "Reminder access is needed to create reminder.")
            break
        case .notDetermined:
            eventStore.requestAccess(to: .reminder, completion: { (granted, error) -> Void in
                if granted{
                    self.createReminder(eventStore: self.eventStore, title: "School Manager", note: self.notesTextView.text, reminderdate: self.selectedDate)
                }else{
                    self.createAlert(title: "Need Reminder Access", message: "Reminder access is needed to create reminder.")
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in  }))
        present(alert, animated: true, completion: nil)
    }
    
    func createAlert(title:String, message:String){
        //Create an alert to get acess to calendar
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Alert_GotToSettings".localized, style: .default, handler: { (UIAlertAction) -> Void in
            let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(openSettingsUrl! as URL)
        }))
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .cancel, handler: { (UIAlertAction) -> Void in }))
        present(alert, animated: true, completion: nil)
    }
    
    func createEvent(eventStore:EKEventStore, title:String, note:String, startdate:NSDate, enddate:NSDate){
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.notes = note
        event.startDate = startdate as Date
        event.endDate = enddate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        do{
            try eventStore.save(event, span: .thisEvent)
        }catch let error as NSError{
            let alert = UIAlertController(title: "Alert_Error_Title".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in  }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func createReminder(eventStore:EKEventStore, title:String, note:String, reminderdate:NSDate){
        let event = EKReminder(eventStore: eventStore)
        event.title = title
        event.notes = note
        let alarm = EKAlarm(absoluteDate: reminderdate as Date)
        event.addAlarm(alarm)
        event.calendar = eventStore.defaultCalendarForNewReminders()
        do{
            try eventStore.save(event, commit: true)
        }catch let error as NSError{
            let alert = UIAlertController(title: "Alert_Error_Title".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in  }))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
