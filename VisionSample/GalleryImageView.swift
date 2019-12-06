//
//  GalleryImageView.swift
//  VisionSample
//
//  Created by Liz W on 11/8/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import Photos

class GalleryImageView: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var photoGallery : [GalleryImage] = []
    private lazy var imageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      getImages()
    }
    
    private lazy var thumbnailSize: CGSize = {
      let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
      return CGSize(width: cellSize.width * UIScreen.main.scale,
                    height: cellSize.height * UIScreen.main.scale)
    }()
    
    /* gets the CoreData entries */
    func getImages() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let result = try context.fetch (request)
            for data in result as! [NSManagedObject] {
                loadImage(data)
            }
        }
        catch {
            print("Failed")
        }
    }
    
    /* adds each CoreData entry to the photoGallery array,
     so that each entry is displayed in the CollectionView */
    func loadImage(_ data: NSManagedObject){
        let newImage = GalleryImage()
        newImage.name = data.value(forKey: "name") as? String
        newImage.favorited = (data.value(forKey: "favorited") as! Bool)
        newImage.photo = UIImage(data:(data.value(forKey: "photo") as! NSData) as Data, scale:1.0)
        photoGallery.append(newImage)
    }
    
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return photoGallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      let asset = photoGallery[indexPath.item].photo
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GalleryImageViewCell
      
      if (asset != nil) {
        cell.imageView?.image = asset
      }

      return cell
    }
    
    /* the next few colectionView methods format the
     collectionView's display
     of cell items */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
  
    /*this segue sends the tapped-on image's data
     (image binary data, text label, and favorited status)
     to the ImageView file
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shoeImage" {
            if let cell = sender as? GalleryImageViewCell, let indexPath = self.collectionView!.indexPath(for: cell) {
                let galleryImage = photoGallery[indexPath.row]
                (segue.destination as! ImageView).detailItem = galleryImage
            }
    }
  }
    
}
