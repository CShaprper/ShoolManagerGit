//
//  TimePlanerCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

@IBDesignable
class TimePlanerCell: UICollectionViewCell {
    
    @IBOutlet var BackgroundImage: UIImageView!
    @IBOutlet var subjectColorView: UIView!
    @IBOutlet var roomLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var teacherLabel: UILabel!
    @IBOutlet var subjectImage: UIImageView!
    @IBOutlet var teacherImage: UIImageView!
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        setup()
    }
    override init(frame:CGRect){
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
    }
    func unhideUIElements(){
        self.BackgroundImage.isHidden = false
        self.teacherLabel.isHidden = false
        self.teacherImage.isHidden = false
        self.subjectImage.isHidden = false
        self.subjectLabel.isHidden = false
        self.roomLabel.isHidden = false
        self.subjectColorView.isHidden = false
        self.roomLabel.textAlignment = NSTextAlignment.left
        self.subjectLabel.textAlignment = NSTextAlignment.left
        self.teacherLabel.textAlignment = NSTextAlignment.left
    }
    
    func hideUIElements(){
        self.BackgroundImage.isHidden = true
        self.subjectColorView.isHidden = true
        self.teacherLabel.isHidden = true
        self.teacherImage.isHidden = true
        self.subjectImage.isHidden = true
        self.subjectLabel.isHidden = true
        self.roomLabel.isHidden = true
    }
    
    func configureCell(tte:TimeTableElement, indexPath:NSIndexPath){
        let ele = tte.planerElements[indexPath.row]
        if (ele.isEmptyElement == false && ele.isHeaderElement == false){
            self.unhideUIElements()
            self.BackgroundImage.isHidden = true
            let col = ColorHelper.convertHexToUIColor(hexColor: ele.subject!.color!)
            self.subjectColorView.layer.backgroundColor = col.cgColor
            self.subjectColorView.layer.cornerRadius = 5
            self.layer.cornerRadius = 5
            self.teacherLabel.text = ele.teacher!.name
            self.teacherImage.image = UIImage(named: ele.teacher!.iamgeName!)
            self.subjectImage.image = UIImage(named: ele.subject!.imageName!)
            self.subjectLabel.text = ele.subject!.subject!
            self.roomLabel.text = "\("MainVC_NowRoomLabelText".localized) \(ele.room!)"
            self.roomLabel.font = UIFont(name: "Chalkboard SE", size: 12)
            self.layer.backgroundColor = UIColor.black.cgColor
            //UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(5), layer: self.layer)
        }
        if (ele.isEmptyElement == true && ele.isHeaderElement == false){
            //Build an empty clear element
            self.hideUIElements()
            self.BackgroundImage.isHidden = false
            self.BackgroundImage.image = UIImage(named: "PalmsTransparent")
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
        if (ele.isEmptyElement == true && ele.isHeaderElement == true){
            //Build an empty orange element
            self.hideUIElements()
            self.layer.backgroundColor = UIColor.brown.cgColor
        }
        if (ele.isEmptyElement == false && ele.isHeaderElement == true){
            self.hideUIElements()
            self.layer.backgroundColor = UIColor.brown.cgColor
            if (ele.day != nil && ele.hour == nil){
                self.roomLabel.isHidden = false
                self.roomLabel.text = ele.day!.day
                self.roomLabel.font = UIFont(name: "Chalkboard SE", size: 25)
                self.roomLabel.textAlignment = NSTextAlignment.center
            }else if (ele.day == nil && ele.hour != nil) {
                self.roomLabel.isHidden = false
                self.roomLabel.text = NSDate.hourFormatter(date: ele.hour!.startTime! as NSDate)
                self.roomLabel.font = UIFont(name: "Chalkboard SE", size: 12)
                self.roomLabel.textAlignment = NSTextAlignment.center
                self.teacherLabel.isHidden = false
                self.teacherLabel.text = NSDate.hourFormatter(date: ele.hour!.endTime! as NSDate)
                self.teacherLabel.font = UIFont(name: "Chalkboard SE", size: 12)
                self.teacherLabel.textAlignment = NSTextAlignment.center
            }
        }
    }
}
