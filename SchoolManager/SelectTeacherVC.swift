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
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        teacherTableView.backgroundColor  = UIColor.clear
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTeacherCollection()
    }
    
    
    /*TableView Delegate    ###############################################################################################################*/
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherSelectCell") as? TeacherSelectCell{
            cell.CofigureCell(teacher: teacherCollection[indexPath.row])
            return cell
        }else{
            return TeacherSelectCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.indexPathForSelectedRow 
        self.performSegue(withIdentifier: "unwindToPlanerSetup", sender: teacherCollection[indexPath.row])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherCollection.count
    }
    
    
    /*MARK: Navigation    ###############################################################################################################*/
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? PlanerSetupVC{
            print("Segue from: \(segue.source.title!) to: \(dest.title!)")
            dest.selectedTeacher = sender as? Teacher
            dest.unwindToPlanerSetup(segue: segue)
        }
    }
    
    
    /*Helper Functions    ###############################################################################################################*/
    func reloadTeacherCollection(){
        teacherCollection = Teacher.FetchData(appDel.managedObjectContext)
        self.teacherTableView.reloadData()
        self.teacherTableView.AnimateTable()
    }
}
