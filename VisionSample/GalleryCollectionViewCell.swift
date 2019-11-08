//
//  GalleryCollectionViewCell.swift
//  VisionSample
//
//  Created by Liz W on 11/7/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GallerycCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var galleryImage: UIImageView!
    
    func displayContent(image: UIImage) {
        galleryImage.image = image
    }
    
}
