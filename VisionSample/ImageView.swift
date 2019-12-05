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
    @IBOutlet weak var logoImage: UIImageView!
    
        override func viewDidLoad() {
          super.viewDidLoad()
          print("AAAAAAAAAAAAAAAAAAAAA")
          classificationLabel.text = self.label
          imageView.image = self.shoe
          logoImage.image = self.logo
          let saveButton = UIImage(named: "emptyStar")
          let savedButton = UIImage(named: "filledStar")
//          favoriteButton.backgroundColor = UIColor.white
          favoriteButton.setImage(saveButton, for: .normal)
          favoriteButton.setImage(savedButton, for: .selected)
          
        }
    
    var detailItem: GalleryImage? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
  var label: String = ""
  var shoe: UIImage = UIImage(named: "pngtest1")!
  var logo: UIImage = UIImage(named: "pngtest1")!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: GalleryImage = self.detailItem {
//          print(self.detailItem!.name)
          print("We got something")
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
//          classificationLabel.text = name
//          imageView.image = detail.photo
//            if let name = self.classificationLabel {
//              print("set the name")
//                name.text = detail.name
//            }
//            if let picture = self.imageView {
//              print("set the picture")
//                picture.image = detail.photo
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favorite() {
//      if favoriteButton.backgroundColor == UIColor.white {
//          favoriteButton.backgroundColor = UIColor.blue
//      }
//      else if favoriteButton.backgroundColor == UIColor.blue {
//          favoriteButton.backgroundColor = UIColor.white
//      }
      print("Favorite button")
      favoriteButton.isSelected.toggle()
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
            print("Did you reach here?")
          var image =  UIImage(contentsOfFile: "Group_!2")
            print("Did you crash here?")
            if imageView.image != nil{
                print("Have you crashed yet?")
                image = imageView.image
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
