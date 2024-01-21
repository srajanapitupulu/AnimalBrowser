//
//  PhotosCell.swift
//  AnimalBrowser
//
//  Created by Samuel Napitupulu on 19/01/24.
//

import UIKit
import SkeletonView

class PhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageFavorite: UIImageView!
    @IBOutlet weak var lblCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.isSkeletonable = true
    }
}
