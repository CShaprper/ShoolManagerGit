//
//  SlectSubjectAtNoteCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 19.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class SelectSubjectAtNoteCell: UITableViewCell {
    @IBOutlet var SubjectImage: UIImageView!
    @IBOutlet var SubjectLabel: UILabel!
    @IBOutlet var subjectColorView: UIView!
    
    func configureCell(sub:Subject){
        self.layer.cornerRadius = 15
        //self.backgroundColor = self.convertHexToUIColor(hexColor: sub.color!)
        self.SubjectImage.image = UIImage(named: sub.imageName!)
        self.SubjectLabel.text = sub.subject
        self.SubjectLabel.layer.cornerRadius = 15
        self.subjectColorView.backgroundColor  = UIColor.clearColor()
        self.subjectColorView.layer.cornerRadius = 5
        self.subjectColorView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: sub.color!)
    }

}
