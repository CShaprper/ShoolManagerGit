//
//  SubjectCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 28.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class SubjectCell: UITableViewCell {
    /*Outlets / Members    ###############################################################################################################*/
    @IBOutlet var SubjectImage: UIImageView!
    @IBOutlet var SubjectLabel: UILabel!
    @IBOutlet var SubjectColorImageView: UIView!
    
    func configureCell(sub:Subject){
        self.SubjectImage.image = UIImage(named: sub.imageName!)
        self.SubjectLabel.text = sub.subject
        self.SubjectColorImageView.layer.cornerRadius = 5
        self.SubjectColorImageView.backgroundColor = ColorHelper.convertHexToUIColor(hexColor: sub.color!)
        self.layer.cornerRadius = 15 
    }
}
