//
//  SettingVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 21.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit
import CoreData

class EnabledDaysSettingsVC: UIViewController {
    //Outlets
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
    
    // Coret Data context
    var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the State of UISwitches corresponding to saved values
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
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_MondaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("1", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchMonday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_MondaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    @IBAction func switchTuesdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchTuesday.on {
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_TuesdaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("2", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchTuesday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_TuesdaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    @IBAction func switchWensdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchWensday.on {
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_WensdaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("3", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchWensday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_WensdaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    @IBAction func switchThursdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchThursday.on {
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_ThursdaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("4", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchThursday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_ThursdaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    @IBAction func switchFridayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchFriday.on {
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_FridaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("5", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchFriday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_FridaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    @IBAction func switchSaturdayAction(sender: AnyObject) {
        //saves new day Monday to core data
        if switchSaturday.on {
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_SaturdaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("6", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchSaturday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_SaturdaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    @IBAction func switchSundayAction(sender: AnyObject) {
        if switchSunday.on {
            let rep = DayRepository(context: context)
            let entity = rep.CreateEmptyEntityObject(Day.EntityName)
            entity.setValue(lbl_SundaySwitch.text!, forKey: Day.Key_day)
            entity.setValue("7", forKey: Day.Key_id)
            rep.Save(entity)
        }
        if !switchSunday.on{
            let rep = DayRepository(context: context)
            let entity = rep.FetchDataWithPredicate(Day.EntityName, predicateKey: Day.Key_day, value: lbl_SundaySwitch.text!)
            if entity != nil{
                for i in 0..<entity!.count{
                    rep.DeleteData(entity![i])
                }
            }
        }
    }
    
    /**Sets the initial state of the Enabled Days switches
     corresponding to saved days in core data*/
    func SetSwitchStateCorrespondingToSavedValues(){
        
        let rep = DayRepository(context: context)
        let fetchResults = rep.FetchData(Day.EntityName)
        let days = fetchResults as! [Day]?
        if days != nil {
            for i in 0..<days!.count{
                
                switch days![i].valueForKey("day")! as! String{
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
                print(days![i].valueForKey("day")!)
            }
        }
    }
}
