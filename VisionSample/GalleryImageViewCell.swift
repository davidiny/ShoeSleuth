//
//  GalleryImageViewCell.swift
//  VisionSample
//
//  Created by Liz W on 11/8/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class GalleryImageViewCell: UICollectionViewCell {
    
  @IBOutlet var imageView: UIImageView?
    
    override func prepareForReuse() {
      super.prepareForReuse()
      //imageView.image = nil
    }
    
    /*func flash() {
      imageView.alpha = 0
      setNeedsDisplay()
      UIView.animate(withDuration: 0.5, animations: { [weak self] in
        self?.imageView.alpha = 1
      })
    }*/
}
