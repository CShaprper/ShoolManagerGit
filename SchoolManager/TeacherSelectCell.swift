//
//  TeacherSelectCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 28.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class TeacherSelectCell: UITableViewCell {
    @IBOutlet weak var teacherimage:UIImageView!
    @IBOutlet weak var teacherlabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func CofigureCell(teacher:Teacher){
        teacherimage.image = UIImage(named: teacher.iamgeName!)
        teacherlabel.text = teacher.name
        self.backgroundColor = UIColor.clearColor()
    }
    
}
