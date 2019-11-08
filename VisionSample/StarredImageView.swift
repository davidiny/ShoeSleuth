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

class StarredImageView: UICollectionViewController {

    var photoGallery : [GalleryImage] = []
    private lazy var imageManager = PHCachingImageManager()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      print("something happened")
      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
//      self.registerClass(GalleryImageViewCell.self)
      getImages()

      print(":^) Gallery image loaded")
    }
    
    private lazy var thumbnailSize: CGSize = {
      let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
      return CGSize(width: cellSize.width * UIScreen.main.scale,
                    height: cellSize.height * UIScreen.main.scale)
    }()
    
    func getImages() -> Void {
        print("Getting images")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        do {
            let result = try context.fetch (request)
            for data in result as! [NSManagedObject] {
              if data.value(forKey: "Favorited") as! Bool == true  {
                loadImage(data)
              }
            }
        }
        catch {
            print("Failed")
        }
    }
    
    func loadImage(_ data: NSManagedObject){
        print("loading images")
        let newImage = GalleryImage()
        newImage.name = data.value(forKey: "name") as? String
        newImage.favorited = (data.value(forKey: "favorited") as! Bool)
      print("photo data: ", data.value(forKey: "photo") as! NSData)
        newImage.photo = UIImage(data:(data.value(forKey: "photo") as! NSData) as Data, scale:1.0)
        print("newImage", newImage.photo!)
        photoGallery.append(newImage)
        print("count: ", photoGallery.count)
    }
    
    // MARK: UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return photoGallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      let asset = photoGallery[indexPath.item].photo
      print("asset: ", asset!)
      print("indexPath: ", indexPath.item)
      print("photoGallery item: ", photoGallery[indexPath.item])
      //let cell = photoGallery[indexPath.row].photo
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StarredImageViewCell
      
      if (asset != nil) {
        print("why aren't you working")
        cell.imageView?.image = asset
      }

      return cell
    }

/*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let asset = photoGallery[indexPath.item].photo
      if let cell = collectionView.cellForItem(at: indexPath) as? GalleryImageViewCell {
        cell.flash()
      }
      imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
        guard let image = image, let info = info else { return }
          if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as?
              Bool, !isThumbnail {
              self?.selectedPhotosSubject.onNext(image)
          }
        
      })
    }
 */
    
}