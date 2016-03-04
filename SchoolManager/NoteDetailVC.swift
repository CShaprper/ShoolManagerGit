//
//  NoteDetailVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 01.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit
import iAd

class NoteDetailVC: UIViewController, ADBannerViewDelegate, UITextViewDelegate {
    /*MARK: Member / Outlets    ###############################################################################################################*/
    @IBOutlet var notePaper: UIImageView!
    var isUserChosen:Bool = false
    var selectedNote:Note!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /*MARK: ViewController Lifecycle    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.boolForKey(appDel.removeAdsIdentifier){
            loadAds()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadNoteWithID:", name: "loadNoteWithID", object: nil)
            setUIValues()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    private func loadNoteWithID(notification:NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let noteID = userInfo["NoteID"]
        let notes = Note.fetchNoteWithID(noteID!, context: appDel.managedObjectContext)
        selectedNote = notes!.count > 0 ? notes![0] : nil
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
    
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func setUIValues(){
        let stack = UIStackView(frame: CGRectMake(0.10 * notePaper.bounds.width, 0.15 * notePaper.bounds.height, notePaper.bounds.width - 2 * 0.10 * notePaper.bounds.width, notePaper.bounds.height - 2 * 0.15 * notePaper.bounds.height))
        stack.axis = .Vertical
        stack.alignment = .Fill
        
        let subjectLbl = UILabel()
        subjectLbl.backgroundColor = UIColor.clearColor()
        subjectLbl.textColor = UIColor.blackColor()
        subjectLbl.font = UIFont(name: "Chalkboard SE", size: 22)
        subjectLbl.text = selectedNote.subject!.subject!
        subjectLbl.textAlignment = .Center
        stack.addArrangedSubview(subjectLbl)
        
        //Configure Notes TextView
        let myTextView = UITextView()
        myTextView.text = selectedNote.note!
        myTextView.backgroundColor = UIColor.clearColor()
        myTextView.textColor = UIColor.blackColor()
        myTextView.font = UIFont(name: "Chalkboard SE", size: 17)
        myTextView.text = selectedNote.note!
        stack.addArrangedSubview(myTextView)
        
        if selectedNote.reminderDate != nil{
            let dueDateLbl = UILabel()
            dueDateLbl.backgroundColor = UIColor.clearColor()
            dueDateLbl.textColor = UIColor.blackColor()
            dueDateLbl.font = UIFont(name: "Chalkboard SE", size: 10)
            dueDateLbl.text = NSDate.dateTimeFormatter(selectedNote.reminderDate!)
            dueDateLbl.textAlignment = .Left
            stack.addArrangedSubview(dueDateLbl)
        }
        
        notePaper.addSubview(stack)
    }
    /*MARK: GestureRecognizer Handles    ###############################################################################################################*/    
    @IBAction func longPressAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Alert_Delete_Title".localized, message: "", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Alert_Action_Delete".localized, style: .Destructive, handler: { (UIAlertAction) -> Void in            
            NotificationManager.removeNotification(self.selectedNote.guid!)
            Note.deleteNote(self.selectedNote, context: self.appDel.managedObjectContext)
            self.performSegueWithIdentifier("unwindToNotesFromDetailsPage", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Alert_Action_Cancel".localized, style: .Default, handler: { (UIAlertAction) -> Void in  }))
        presentViewController(alert, animated: true, completion: nil)
    }
}
