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
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var subjectsCollection:[Subject]!
    
    /*MARK: ViewController Delagates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        subjectsTableView.backgroundColor  = UIColor.clear
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadSubjectsTableView()
    }

    // MARK: - Table view data source
    /*MARK: Tableview Data Source    ###############################################################################################################*/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.subjectsCollection.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "unwindToPlanerSetup", sender: self.subjectsCollection[indexPath.row])
    }
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectSubjectCell") as? SelectSubjectCell{
            cell.configureCell(sub: self.subjectsCollection[indexPath.row])
            return cell
        }else{
            return SelectSubjectCell()
        }
    }

   /*MARK: Navigation    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Segue from: \(String(describing: segue.source.title)) to: \(String(describing: segue.destination.title))")
        if let dest = segue.destination as? PlanerSetupVC{
            dest.selectedSubject = sender as? Subject
            dest.unwindToPlanerSetup(segue: segue)
        }
    }

    /*MARK: Helper Functions    ###############################################################################################################*/
    func reloadSubjectsTableView(){
        self.subjectsCollection = Subject.FetchData(appDel.managedObjectContext)
        self.subjectsTableView.reloadData()
        self.subjectsTableView.AnimateTable()
    }

}
