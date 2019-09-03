//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Jag Stang on 19/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var noteColorView: UIView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noteColorView.layer.borderWidth = 1
        noteColorView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = noteColorView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            noteColorView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = noteColorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            noteColorView.backgroundColor = color
        }
    }
}
