//
//  MainCollectionViewCell.swift
//  PictureGallery
//
//  Created by Valeria Muldt on 26.10.2020.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var titleWidthConstraint: NSLayoutConstraint! {
        didSet {
            titleWidthConstraint.constant = UIScreen.main.bounds.width / 3
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = UIImage(named: "placeholder")
    }
}
