//
//  SelectHourVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 29.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SelectHourVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    /*MARK: Outlet / Member
    ###############################################################################################################*/
    @IBOutlet var hoursTableView: UITableView!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var hoursCollection:[TimelineData]!
    
    /*MARK: ViewController Delegates
    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        hoursTableView.backgroundColor  = UIColor.clearColor()  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadHoursCollection()
    }
    
    
    /*MARK: TableView Delegates    ###############################################################################################################*/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         _ = tableView.indexPathForSelectedRow
        self.performSegueWithIdentifier("unwindToPlanerSetup", sender: hoursCollection[indexPath.row])
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SelectHourCell") as? SelectHourCell{
            cell.cofigureCell(hoursCollection[indexPath.row])
            return cell
        }
        return SelectHourCell()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hoursCollection.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*MARK: Navigation
    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? PlanerSetupVC{
            print("Segue from: \(segue.sourceViewController.title) to: \(segue.destinationViewController.title)")
            dest.selectedHour = sender as? TimelineData
            dest.unwindToPlanerSetup(segue)
        }
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
   func reloadHoursCollection(){
    self.hoursCollection = TimelineData.FetchData(appDel.managedObjectContext)
    self.hoursTableView.reloadData()
    self.hoursTableView.AnimateTable()
    }
}
