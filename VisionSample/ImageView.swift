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
    /* receives segue data from GalleryImageview,
     and StarredImageView */

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    
        override func viewDidLoad() {
          super.viewDidLoad()
          classificationLabel.text = self.label
          imageView.image = self.shoe
          logoImage.image = self.logo
          let saveButton = UIImage(named: "emptyStar")
          let savedButton = UIImage(named: "filledStar")
          favoriteButton.setImage(saveButton, for: .normal)
          favoriteButton.setImage(savedButton, for: .selected)
          
        }
    
    //segue data
    var detailItem: GalleryImage? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
  var label: String = ""
  var shoe: UIImage = UIImage(named: "pngtest1")!
  var logo: UIImage = UIImage(named: "pngtest1")!
    
    // adds the segue data to the storyboard
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: GalleryImage = self.detailItem {
          self.label = (String(detail.name!))
          self.shoe = (detail.photo!)
          if self.label == "We're Pretty Sure These are Nike Shoes" || self.label == "These Might Be Nike shoes" {
            self.logo = UIImage(named: "Nike")!
          }
          if self.label == "We're Pretty Sure These are Adidas Shoes" || self.label == "These Might Be Adidas shoes" {
            self.logo = UIImage(named: "adidas")!
          }
          if self.label == "We're Pretty Sure These are UnderArmour Shoes" || self.label == "These Might Be UnderArmour shoes" {
            self.logo = UIImage(named: "underarmour")!
          }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* finds the item in CoreData via the binary data,
     then changes the favorited status*/
    @IBAction func favorite() {
      favoriteButton.isSelected.toggle()
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
          var image =  UIImage(contentsOfFile: "Group_!2")
            if imageView.image != nil{
                image = imageView.image
          }

          if (data.value(forKey: "photo") as? Data == UIImagePNGRepresentation(image!))  { // check if image is same
            if data.value(forKey: "Favorited") as! Bool == true {
              data.setValue(false, forKey: "Favorited")
            }
            else {
              data.setValue(true, forKey: "Favorited")
            }
            try context.save()
          }
        }
      }
      catch {
        print("Failed")
      }
    }
      
    
    
}
