//
//  DayHeaderCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 02.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class TimeTableHeaderCell: UICollectionReusableView {
    
    @IBOutlet var timeTableHeaderLabel: UILabel!
    
    func configureCell(tte:TimeTableElement, indexPath:NSIndexPath){
        if((tte.planerElements[indexPath.row].isEmptyElement as? Bool) == nil){
            timeTableHeaderLabel.text = ""
        }else{
            let headerString = "\("Hour_Number") \(tte.planerElements[indexPath.row].hour!.hour!) \(NSLocalizedString("MainVC_NowHourStartLabelText", comment: "-")) \(NSDate.hourFormatter(date: tte.planerElements[indexPath.row].hour!.startTime! as NSDate)) \(NSLocalizedString("MainVC_NowHourEndLabelText", comment: "-")) \(NSDate.hourFormatter(date: tte.planerElements[indexPath.row].hour!.endTime! as NSDate))"
        timeTableHeaderLabel.text = headerString
        }
    }
    
    }
