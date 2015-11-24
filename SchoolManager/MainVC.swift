
import UIKit
extension UIViewController {
    
    func preloadView() {
        let _ = view
    }
}


class MainVC: UIViewController {
    //Outlets
    @IBOutlet var btn_Caleandar: UIButton!
    @IBOutlet var lbl_Calendar: UILabel!
    @IBOutlet var btn_Settings: UIButton!
    @IBOutlet var lbl_SettingsButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }  

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    //}


}
