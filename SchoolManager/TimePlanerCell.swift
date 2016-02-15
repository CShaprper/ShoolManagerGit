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
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = 5
    }
    func unhideUIElements(){
        self.BackgroundImage.hidden = false
        self.teacherLabel.hidden = false
        self.teacherImage.hidden = false
        self.subjectImage.hidden = false
        self.subjectLabel.hidden = false
        self.roomLabel.hidden = false
        self.subjectColorView.hidden = false
        self.roomLabel.textAlignment = NSTextAlignment.Left
        self.subjectLabel.textAlignment = NSTextAlignment.Left
        self.teacherLabel.textAlignment = NSTextAlignment.Left
    }
    
    func hideUIElements(){
        self.BackgroundImage.hidden = true
        self.subjectColorView.hidden = true
        self.teacherLabel.hidden = true
        self.teacherImage.hidden = true
        self.subjectImage.hidden = true
        self.subjectLabel.hidden = true
        self.roomLabel.hidden = true
    }
    
    func configureCell(tte:TimeTableElement, indexPath:NSIndexPath){
        let ele = tte.planerElements[indexPath.row]
        if (ele.isEmptyElement == false && ele.isHeaderElement == false){
            self.unhideUIElements()
            self.BackgroundImage.hidden = true
            let col = ColorHelper.convertHexToUIColor(hexColor: ele.subject!.color!)
            self.subjectColorView.layer.backgroundColor = col.CGColor
            self.subjectColorView.layer.cornerRadius = 5
            self.layer.cornerRadius = 5
            self.teacherLabel.text = ele.teacher!.name
            self.teacherImage.image = UIImage(named: ele.teacher!.iamgeName!)
            self.subjectImage.image = UIImage(named: ele.subject!.imageName!)
            self.subjectLabel.text = ele.subject!.subject!
            self.roomLabel.text = "\("MainVC_NowRoomLabelText".localized) \(ele.room!)"
            self.roomLabel.font = UIFont(name: "Chalkboard SE", size: 12)
            self.layer.backgroundColor = UIColor.blackColor().CGColor
            //UIDesignHelper.ShadowMaker(UIColor.blackColor(), shadowOffset: CGFloat(15), shadowRadius: CGFloat(5), layer: self.layer)
        }
        if (ele.isEmptyElement == true && ele.isHeaderElement == false){
            //Build an empty clear element
            self.hideUIElements()
            self.BackgroundImage.hidden = false
            self.BackgroundImage.image = UIImage(named: "PalmsTransparent")
            self.layer.backgroundColor = UIColor.clearColor().CGColor
        }
        if (ele.isEmptyElement == true && ele.isHeaderElement == true){
            //Build an empty orange element
            self.hideUIElements()
            self.layer.backgroundColor = UIColor.brownColor().CGColor
        }
        if (ele.isEmptyElement == false && ele.isHeaderElement == true){
            self.hideUIElements()
            self.layer.backgroundColor = UIColor.brownColor().CGColor
            if (ele.day != nil && ele.hour == nil){
                self.roomLabel.hidden = false
                self.roomLabel.text = ele.day!.day
                self.roomLabel.font = UIFont(name: "Chalkboard SE", size: 25)
                self.roomLabel.textAlignment = NSTextAlignment.Center
            }else if (ele.day == nil && ele.hour != nil) {
                self.roomLabel.hidden = false
                self.roomLabel.text = NSDate.hourFormatter(ele.hour!.startTime!)
                self.roomLabel.font = UIFont(name: "Chalkboard SE", size: 12)
                self.roomLabel.textAlignment = NSTextAlignment.Center
                self.teacherLabel.hidden = false
                self.teacherLabel.text = NSDate.hourFormatter(ele.hour!.endTime!)
                self.teacherLabel.font = UIFont(name: "Chalkboard SE", size: 12)
                self.teacherLabel.textAlignment = NSTextAlignment.Center
            }
        }
    }
}
