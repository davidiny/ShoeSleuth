//
//  GalleryCollectionView.swift
//  VisionSample
//
//  Created by Liz W on 11/7/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class GalleryPhotosViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImages {
            self.collectionView!.reloadSections(IndexSet(integer: 0))
        }
    }

    var photoGallery: [UIImage] = []
    
    func getImages(completion: @escaping () -> Void) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let context = appDelegate.persistentContainer.viewContext
     let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
     request.returnsObjectsAsFaults = false
     do {
       let result = try context.fetch(request)
       
       for data in result as! [NSManagedObject] {
        self.photoGallery.append(UIImage(data: (data.value(forKey: "photo") as! NSData) as Data, scale:1.0)!)
       }
     }
     catch {
       print("Failed")
     }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoGallery.count
    }
    
    
    
}

