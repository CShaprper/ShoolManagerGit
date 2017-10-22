//
//  AddSubjectNoteVC.swift
//  SchoolManager
//
//  Created by Peter Sypek on 19.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class SelectSubjectNoteVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate  {
    /*MARK: Outlets Members    ###############################################################################################################*/
    @IBOutlet var subjectsTableView: UITableView!
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var subjectsCollection:[Subject]!
    
    /*MARK: ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        subjectsTableView.backgroundColor  = UIColor.clearColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadSubjectsTableView()
    }

    /*MARK: TableView Delagates    ###############################################################################################################*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SelectSubjectAtNoteCell") as? SelectSubjectAtNoteCell{
            cell.configureCell(self.subjectsCollection[indexPath.row])
            return cell
        }else{
            return SelectSubjectAtNoteCell()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsCollection.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("unwindToAddNote", sender: self.subjectsCollection[indexPath.row])
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /*MARK: Navigation    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? AddNoteVC{
            dest.selectedSubject = sender as? Subject
            dest.unwindToAddNote(segue)
        }
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func reloadSubjectsTableView(){
        self.subjectsCollection = Subject.FetchData(appDel.managedObjectContext)
        self.subjectsTableView.reloadData()
        self.subjectsTableView.AnimateTable()
    }
}
