//
//  GalleryViewCell.swift
//  Notes
//
//  Created by Jag Stang on 20/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

}
