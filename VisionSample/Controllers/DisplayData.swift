/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A class that represents the data shown in the collection view.
*/

import UIKit
import CoreData

/// A type to represent how model data should be displayed.
class DisplayData: NSObject {
  
  func favorite() {
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
  
    
    var color: UIColor = .red
    
    // Add additional properties for your own configuration here.
}
