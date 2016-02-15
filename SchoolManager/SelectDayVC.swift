
import UIKit

class SelectDayVC: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    /*Outlet / Members
    ###############################################################################################################*/
    @IBOutlet var dayTableView: UITableView!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var dayCollection:[Day]!
    
    /*MARK: ViewController Delegates
    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        popoverPresentationController?.delegate = self
        dayTableView.backgroundColor  = UIColor.clearColor()  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadDayCollection()
    }
    
    
    /*MARK: Navigation
    ###############################################################################################################*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? PlanerSetupVC{
            print("Segue from: \(segue.sourceViewController.title) to: \(segue.destinationViewController.title)")
            dest.selectedDay = sender as? Day
            dest.unwindToPlanerSetup(segue)
        }
    }
    
    /*MARK: TableView Delegates
    ###############################################################################################################*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SelectDayCell") as? SelectDayCell{
            cell.configureCell(dayCollection[indexPath.row])
            return cell
        }
        return SelectDayCell()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow
        self.performSegueWithIdentifier("unwindToPlanerSetup", sender: dayCollection[indexPath.row])
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayCollection.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /*Helper Functions
    ###############################################################################################################*/
    func reloadDayCollection(){
        self.dayCollection = Day.FetchData(appDel.managedObjectContext)
        self.dayTableView.reloadData()
        self.dayTableView.AnimateTable()
    }
}
