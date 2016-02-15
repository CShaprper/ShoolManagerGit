//
//  SelectSubjectController.swift
//  SchoolManager
//
//  Created by Peter Sypek on 30.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SelectSubjectVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate  {
    /*MARK: Outlets Members    ###############################################################################################################*/
    @IBOutlet var subjectsTableView: UITableView!
    
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var subjectsCollection:[Subject]!
    
    /*MARK: ViewController Delagates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        subjectsTableView.backgroundColor  = UIColor.clearColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadSubjectsTableView()
    }

    // MARK: - Table view data source
    /*MARK: Tableview Data Source    ###############################################################################################################*/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.subjectsCollection.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
       self.performSegueWithIdentifier("unwindToPlanerSetup", sender: self.subjectsCollection[indexPath.row])
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SelectSubjectCell") as? SelectSubjectCell{
            cell.configureCell(self.subjectsCollection[indexPath.row])
            return cell
        }else{
            return SelectSubjectCell()
        }
    }

   /*MARK: Navigation    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue from: \(segue.sourceViewController.title) to: \(segue.destinationViewController.title)")
        if let dest = segue.destinationViewController as? PlanerSetupVC{
            dest.selectedSubject = sender as? Subject
            dest.unwindToPlanerSetup(segue)
        }
    }

    /*MARK: Helper Functions    ###############################################################################################################*/
    func reloadSubjectsTableView(){
        self.subjectsCollection = Subject.FetchData(appDel.managedObjectContext)
        self.subjectsTableView.reloadData()
        self.subjectsTableView.AnimateTable()
    }

}
