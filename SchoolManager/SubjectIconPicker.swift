//
//  SubjectIconPicker.swift
//  SchoolManager
//
//  Created by Peter Sypek on 30.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SubjectIconPicker: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /*MARK: Outlet / Member    ###############################################################################################################*/
    @IBOutlet var ImageCollectionView: UICollectionView!
    var iconCollection:[String]!
    
    /*MARK: ViewController Delegates    ###############################################################################################################*/
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageCollectionView.backgroundColor = UIColor.clear
        loadIconList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*MARK: Collection view Datasource & Delegate functions    ###############################################################################################################*/
    // return number of section in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    // return number of cell shown within collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconCollection.count
    }
    // create collection view cell content
    private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // deque reusable cell from collection view.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconPickerCell", for: indexPath as IndexPath) as? IconPickerCell{
            cell.configureCell(imagePath: self.iconCollection[indexPath.row])
            return cell
        }else{
            return IconPickerCell()
        }
    }
    // function - called when clicked on a collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "unwindToSubjects", sender: iconCollection[indexPath.row])
    }
    
    /*MARK: Navigation
    ###############################################################################################################*/
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destination as? SubjectsVC{
            print("Segue from: \(String(describing: segue.source.title)) to: \(String(describing: segue.destination.title))")
            dest.selectedImageName = sender as! String!
            dest.unwindToSubjects(segue: segue)
        }
    }
    
    /*MARK: Helper Functions    ###############################################################################################################*/
    func loadIconList(){
        
        // create path for Colors.plist resource file.
        let iconFilePath = Bundle.main.pathForResource("SubjectIcons", ofType: "plist")
        
        // save piist file array content to NSArray object
        let iconPathArray = NSArray(contentsOfFile: iconFilePath!)
        
        // Cast NSArray to string array.
        self.iconCollection = iconPathArray as! [String]
    }
}
