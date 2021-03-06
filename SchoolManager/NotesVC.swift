
import UIKit
import EventKit
import EventKitUI
import iAd

class NotesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate{
    /*MARK: Outlet / Member    ###############################################################################################################*/
    let transition = BounceTransition()
    var notesCollection = [Note]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var selectedNote:Note!
    @IBOutlet var NotesCollectionView: UICollectionView!
    
    /*MARK: ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        if !appDel.userDefaults.boolForKey(appDel.removeAdsIdentifier){
            loadAds()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadNotesCollection()
        self.setNotesBadge()
    }
/*TODO: Overwork
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }*/
    
    /*MARK: Advertising    ###############################################################################################################*/
    func loadAds(){
        self.appDel.adBannerView.removeFromSuperview()
        self.appDel.adBannerView.delegate = nil
        self.appDel.adBannerView = ADBannerView(frame: CGRect.zero)
        
        //ADBanner at the screen Bottom
        self.appDel.adBannerView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - self.appDel.adBannerView.frame.size.height / 2 - 50)
        
        self.appDel.adBannerView.delegate = self
        self.appDel.adBannerView.hidden = true
        view.addSubview(self.appDel.adBannerView)
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        self.appDel.adBannerView.hidden = true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDel.adBannerView.hidden = false
    }
    
    /*MARK: CollectionView Delegates    ###############################################################################################################*/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath UICollectionViewCell {
        if let cell = NotesCollectionView.dequeueReusableCellWithReuseIdentifier("NotesViewCell", forIndexPath: indexPath as IndexPath) as? NotesCollectionViewCell{
            let note = self.notesCollection[indexPath.row]
            cell.configureCell(note)
            return cell
        }
        else{
            return NotesCollectionViewCell()
        }

    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        self.selectedNote = self.notesCollection[indexPath.row]
        self.performSegue(withIdentifier: "ShowNotesDetail", sender: selectedNote)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notesCollection.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    /*MARK: Navigation    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? AddNoteVC{
            dest.transitioningDelegate = transition
        }
        if let dest = segue.destination as? NoteDetailVC{
            dest.selectedNote = sender as! Note
            dest.isUserChosen = true
            dest.transitioningDelegate = transition
        }
    }
    @IBAction func unwindToNotes(segue:UIStoryboardSegue){
        
    }
    
    
    /*MARK: @IBActions    ###############################################################################################################*/
    
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func reloadNotesCollection(){
        self.notesCollection = Note.FetchData(context: appDel.managedObjectContext)!
        if notesCollection.count > 0 {
        self.tabBarController!.tabBarItem.badgeValue = "\(notesCollection.count)"
        } else {
            self.tabBarController!.tabBarItem.badgeValue = nil
        }
        self.NotesCollectionView.reloadData()
    }
    
    
    private func setNotesBadge(){
        let notes = Note.FetchData(appDel.managedObjectContext)
        let tabBarController = appDel.window?.rootViewController as! UITabBarController
        let tabBarRootViewControllers: Array = tabBarController.viewControllers!
        if notes!.count > 0{
            tabBarRootViewControllers[2].tabBarItem.badgeValue = "\(notes!.count)"
        } else {
            tabBarRootViewControllers[2].tabBarItem.badgeValue = nil
        }
    }
}
