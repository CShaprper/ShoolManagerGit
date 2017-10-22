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
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var hoursCollection:[TimelineData]!
    
    /*MARK: ViewController Delegates
    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        hoursTableView.backgroundColor  = UIColor.clear
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadHoursCollection()
    }
    
    
    /*MARK: TableView Delegates    ###############################################################################################################*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         _ = tableView.indexPathForSelectedRow
        self.performSegue(withIdentifier: "unwindToPlanerSetup", sender: hoursCollection[indexPath.row])
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SelectHourCell") as? SelectHourCell{
            cell.cofigureCell(timeline: hoursCollection[indexPath.row])
            return cell
        }
        return SelectHourCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hoursCollection.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*MARK: Navigation
    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? PlanerSetupVC{
            print("Segue from: \(String(describing: segue.source.title)) to: \(String(describing: segue.destination.title))")
            dest.selectedHour = sender as? TimelineData
            dest.unwindToPlanerSetup(segue: segue)
        }
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
   func reloadHoursCollection(){
    self.hoursCollection = TimelineData.FetchData(appDel.managedObjectContext)
    self.hoursTableView.reloadData()
    self.hoursTableView.AnimateTable()
    }
}
