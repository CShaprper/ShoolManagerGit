//
//  NotesCollectionViewCell.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {

    @IBOutlet var notesBGImage: UIImageView!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var notesTextLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!

    func configureCell(note:Note){
        self.subjectLabel.text = note.subject!.subject
        self.notesTextLabel.text = note.note
        self.dueDateLabel.text = NSDate.dateTimeFormatter(date: note.reminderDate!)
        self.notesBGImage.image = UIImage(named: "WhiteNote")
    }
}
