//
//  SelectTeacherVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 28.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SelectTeacherVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate {
    /*Outlets / Members    ###############################################################################################################*/
    @IBOutlet var teacherTableView: UITableView!
    var teacherCollection:[Teacher]!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        teacherTableView.backgroundColor  = UIColor.clearColor()  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTeacherCollection()
    }
    
    
    /*TableView Delegate    ###############################################################################################################*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("TeacherSelectCell") as? TeacherSelectCell{
            cell.CofigureCell(teacherCollection[indexPath.row])
            return cell
        }else{
            return TeacherSelectCell()
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow 
        self.performSegueWithIdentifier("unwindToPlanerSetup", sender: teacherCollection[indexPath.row])
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherCollection.count
    }
    
    
    /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? PlanerSetupVC{
            print("Segue from: \(segue.sourceViewController.title!) to: \(dest.title!)")
            dest.selectedTeacher = sender as? Teacher
            dest.unwindToPlanerSetup(segue)
        }
    }
    
    
    /*Helper Functions    ###############################################################################################################*/
    func reloadTeacherCollection(){
        teacherCollection = Teacher.FetchData(appDel.managedObjectContext)
        self.teacherTableView.reloadData()
        self.teacherTableView.AnimateTable()
    }
}
