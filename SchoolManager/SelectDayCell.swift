//
//  SelectDayCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 29.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SelectDayCell: UITableViewCell {
    @IBOutlet var DayImage: UIImageView!
    @IBOutlet var DayLabel: UILabel!

    func configureCell(day: Day){
        self.backgroundColor = UIColor.clear
        DayLabel.text = day.day
    }
}
