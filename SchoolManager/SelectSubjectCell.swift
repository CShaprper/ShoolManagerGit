//
//  SelectSubjectCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 30.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SelectSubjectCell: UITableViewCell {
    @IBOutlet var SubjectImage: UIImageView!
    @IBOutlet var SubjectLabel: UILabel!
    @IBOutlet var subjectColorView: UIView!
    
    func configureCell(sub:Subject){
        self.layer.cornerRadius = 15
        //self.backgroundColor = self.convertHexToUIColor(hexColor: sub.color!)
        self.SubjectImage.image = UIImage(named: sub.imageName!)
        self.SubjectLabel.text = sub.subject
        self.SubjectLabel.layer.cornerRadius = 15
        self.subjectColorView.backgroundColor  = UIColor.clear
        self.subjectColorView.layer.cornerRadius = 5
        self.subjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: sub.color!)
    }   
        
}
