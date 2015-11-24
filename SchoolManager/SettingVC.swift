//
//  SettingVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 21.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit
import CoreData

class SettingVC: UIViewController {
    @IBOutlet var lbl_EnabledDays: UILabel!
    @IBOutlet var lbl_MondaySwitch: UILabel!
    @IBOutlet var lbl_TuesdaySwitch: UILabel!
    @IBOutlet var lbl_WensdaySwitch: UILabel!
    @IBOutlet var lbl_ThursdaySwitch: UILabel!
    @IBOutlet var lbl_FridaySwitch: UILabel!
    @IBOutlet var lbl_SaturdaySwitch: UILabel!
    @IBOutlet var lbl_SundaySwitch: UILabel!
    
    @IBOutlet var switchMonday: UISwitch!
    @IBOutlet var switchTuesday: UISwitch!
    @IBOutlet var switchWensday: UISwitch!
    @IBOutlet var switchThursday: UISwitch!
    @IBOutlet var switchFriday: UISwitch!
    @IBOutlet var switchSaturday: UISwitch!
    @IBOutlet var switchSunday: UISwitch!
    
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetSwitchStateCorrespondingToSavedValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //Actions
    @IBAction func switchMondayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchMonday.on {
            AddNewDay(lbl_MondaySwitch.text!, idStr: "1")
        }
        if !switchMonday.on{
            DeleteDay(lbl_MondaySwitch.text!)
        }
    }
    
    @IBAction func switchTuesdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchTuesday.on {
            AddNewDay(lbl_TuesdaySwitch.text!, idStr: "2")
        }
        if !switchTuesday.on{
            DeleteDay(lbl_TuesdaySwitch.text!)
        }
    }
    
    @IBAction func switchWensdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchWensday.on {
            AddNewDay(lbl_WensdaySwitch.text!, idStr: "3")
        }
        if !switchWensday.on{
            DeleteDay(lbl_WensdaySwitch.text!)
        }
    }
    
    @IBAction func switchThursdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchThursday.on {
            AddNewDay(lbl_ThursdaySwitch.text!, idStr: "4")
        }
        if !switchThursday.on{
            DeleteDay(lbl_ThursdaySwitch.text!)
        }
    }
    
    @IBAction func switchFridayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchFriday.on {
            AddNewDay(lbl_FridaySwitch.text!, idStr: "5")
        }
        if !switchFriday.on{
            DeleteDay(lbl_FridaySwitch.text!)
        }
    }
    
    @IBAction func switchSaturdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchSaturday.on {
            AddNewDay(lbl_SaturdaySwitch.text!, idStr: "6")
        }
        if !switchSaturday.on{
            DeleteDay(lbl_SaturdaySwitch.text!)
        }
    }
    
    @IBAction func switchSundayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchSunday.on {
            AddNewDay(lbl_SundaySwitch.text!, idStr: "7")
        }
        if !switchSunday.on{
            DeleteDay(lbl_SundaySwitch.text!)
        }
    }
    
    /**Sets the initial state of the Enabled Days switches
     corresponding to saved days in core data*/
    func SetSwitchStateCorrespondingToSavedValues(){
        let fetchResults = FetchDays()
        let days = fetchResults as! [Day]
        if days.count > 0 {
            for i in 0..<days.count{
                
                switch days[i].valueForKey("day")! as! String{
                case lbl_MondaySwitch.text!:
                    switchMonday.on = true
                    break
                case lbl_TuesdaySwitch.text!:
                    switchTuesday.on = true
                    break
                case lbl_WensdaySwitch.text!:
                    switchWensday.on = true
                    break
                case lbl_ThursdaySwitch.text!:
                    switchThursday.on = true
                    break
                case lbl_FridaySwitch.text!:
                    switchFriday.on = true
                    break
                case lbl_SaturdaySwitch.text!:
                    switchSaturday.on = true
                    break
                case lbl_SundaySwitch.text!:
                    switchSunday.on = true
                    break
                default:
                    break
                }
                print(days[i].valueForKey("day")!)
            }
        }
    }
    
    /** Creates Day Entity NSManagedObject
     :returns: Day Entity NSManagedObject*/
    func CreateEmptyDayEntityObject()->NSManagedObject{
        let rep = DayRepository(context: context)
        let day = rep.CreateEmptyEntityObject()
        return day
    }
    
    /**Creates Day Entity NSManagedObject
     :param: strID - String for key ID
     :param: strDay - String for key day
     :returns: Day Entity NSManagedObject*/
    func CreateDayEntityObject(strID: String, strDay: String) -> Day {
        let rep = DayRepository(context: context)
        let day = rep.CreateEmptyEntityObject() as! Day
        //let day = NSEntityDescription.insertNewObjectForEntityForName(Day.EntityName, inManagedObjectContext: self.context) as! Day
        day.id = strID
        day.day = strDay
        return day
    }
    
    /**Saves a NSManagedObject
     How to use:
     let result = saveContext(context)
     if !result.success {
     println("Error: \(result.error)")
     } */
     //func saveContext(self.managedObjectContext!) -> (success: Bool, error: NSError?)
     
     
     /**Adds a new record to Day Entity
     :param: daystring     The day to add as string.*/
    func AddNewDay(dayStr:String, idStr:String){
        let entity = CreateEmptyDayEntityObject()
        
        entity.setValue(dayStr, forKey: Day.Key_day)
        entity.setValue(idStr, forKey: Day.Key_id)
        
        do{
            try self.context.save()
            print(entity)
        }
            
        catch let error as NSError{
            print("\(dayStr) not saved \(error.localizedDescription)")
        }
    }
    
    /**Fetches all records from "Day" Entity
     :returns NSObject?*/
    func FetchDays() ->[NSManagedObject]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: Day.EntityName)
            let fetchResults = try self.context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if fetchResults!.count > 0 {
                return fetchResults
            }
        }
            
        catch let error as NSError{
            print("\(Day.EntityName) not fetched \(error)")
        }
        return nil
    }
    
    
    /**Deletes a specific day from "Day" Eintity
     :param: daystring  The day to delete as String*/
    func DeleteDay(dayString:String){
        do{
            let fetchRequest = NSFetchRequest(entityName: Day.EntityName)
            let sortDescriptor = NSSortDescriptor(key: Day.Key_day, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(Day.Key_day) == %@", dayString)
            fetchRequest.predicate = predicate
            let fetchResults = try self.context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            let days = fetchResults as! [Day]
            if days.count > 0 {
                for i in 0..<days.count{
                    context.deleteObject(days[i])
                }
            }            
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    
}
