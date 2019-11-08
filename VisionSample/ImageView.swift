//
//  ImageView.swift
//  VisionSample
//
//  Created by Liz W on 11/8/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ImageView: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
        override func viewDidLoad() {
          super.viewDidLoad()
        }
    
    var detailItem: GalleryImage? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: GalleryImage = self.detailItem {
            if let name = self.classificationLabel {
                name.text = detail.name
            }
            if let picture = self.imageView {
                picture.image = detail.photo
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favorite() {
      if favoriteButton.backgroundColor == UIColor.white {
          favoriteButton.backgroundColor = UIColor.blue
      }
      else if favoriteButton.backgroundColor == UIColor.blue {
          favoriteButton.backgroundColor = UIColor.white
      }
      print("Favorite button")
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        
        /*for data in result as! [NSManagedObject] {
         if (data.value(forKey: "name") as! String == shoeName.text) {
         
         }
         }*/
        for data in result as! [NSManagedObject] {
          var image =  UIImage(contentsOfFile: "Group_!2")
          if self.imageView.image != nil{
            image = self.imageView.image!
          }

          if (data.value(forKey: "photo") as? Data == UIImagePNGRepresentation(image!))  { // check if image is same
            print("Favoriting")
            if data.value(forKey: "Favorited") as! Bool == true {
              print("Unfavorited")
              data.setValue(false, forKey: "Favorited")
            }
            else {
              print("Favorited!")
              data.setValue(true, forKey: "Favorited")
            }
            try context.save()
            print("Saved again")
            //!data.value(forKey: "Favorited") as! Bool
          }
          //                if data == context {
          //                    /*if (data.value(forKey: "Favorited") == true ) {
          //
          //                    }*/
          //                    print("Favoriting")
          //                    data.setValue(true, forKey: "Favorited")
          //                    //data.setValue(!data.value(forKey: "Favorited") as! Bool, forKey: "Favorited")
          //                    try context.save()
        }
      }
      catch {
        print("Failed")
      }
    }
    
    
}
