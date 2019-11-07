//
//  IdentifiedController.swift
//  VisionSample
//
//  Created by Liz W on 11/4/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class IdentifiedController: UIViewController {
    
    @IBOutlet weak var shoeImage: UIImageView!
    @IBOutlet weak var shoeName: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //var shoeLabel:String = ""
    
    // MARK: - General
    override func viewDidLoad() {
        super.viewDidLoad()
        //maybe automatically run save method when the screen appears
        shoeName.text = shoeName.text
        //note: segue??
    }
    
    //look through coredata to find the autosaved image
    //change its 'favorited' status to true or false
    @IBAction func favorite() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //favorited
            }
        }
        catch {
            print("Failed")
        }
    }
    
    @IBAction func changeFavoriteButtonColor(sender: UIButton) {
        favoriteButton.backgroundColor = UIColor.yellow
    }
    
    func save() {
        let image = GalleryImage()
        image.name = shoeName.text
        image.photo = shoeImage.image
        saveShoe(image: image)
    }
    
    
    func saveShoe(image: GalleryImage){
        // Connect to the context for the container stack
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Specifically select the People entity to save this object to
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        let newImage = NSManagedObject(entity: entity!, insertInto: context)
        // Set values one at a time and save
        newImage.setValue(image.name, forKey: "name")
        newImage.setValue(image.favorited, forKey: "favorited")
        // Safely unwrap the picture
        if let pic = image.photo {
            newImage.setValue(UIImagePNGRepresentation(pic), forKey: "photo")
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    
}
