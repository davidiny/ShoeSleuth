/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 View controller for selecting images and applying Vision + Core ML processing.
 */

import UIKit
import CoreML
import Vision
import ImageIO
import Foundation
import CoreData

class ImageClassificationViewController: UIViewController {
  // MARK: - IBOutlets
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var classificationLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var NikeImage: UIImageView!
  @IBOutlet weak var UnderArmourImage: UIImageView!
  @IBOutlet weak var AdidasImage: UIImageView!
  @IBOutlet weak var HelpLabel: UILabel!
  @IBOutlet weak var HomePhoto: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NikeImage.isHidden = true
    UnderArmourImage.isHidden = true
    AdidasImage.isHidden = true
    classificationLabel.isHidden = true
    favoriteButton.isHidden = true
    favoriteButton.backgroundColor = UIColor.white
    let saveButton = UIImage(named: "emptyStar")
    let savedButton = UIImage(named: "filledStar")
    favoriteButton.setImage(saveButton, for: .normal)
    favoriteButton.setImage(savedButton, for: .selected)
    


    //     favoriteButton.isHidden = true
    
    //maybe automatically run save method when the screen appears
  }

  
  // MARK: - Image Classification
  
  /// - Tag: MLModelSetup
  lazy var classificationRequest: VNCoreMLRequest = {
    do {
      /*
       Use the Swift class `MobileNet` Core ML generates from the model.
       To use a different Core ML classifier model, add it to the project
       and replace `MobileNet` with that model's generated Swift class.
       */
      let model = try VNCoreMLModel(for: ShoeSleuthModel().model)
      
      let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
        self?.processClassifications(for: request, error: error)
      })
      request.imageCropAndScaleOption = .centerCrop
      return request
    } catch {
      fatalError("Failed to load Vision ML model: \(error)")
    }
  }()
  
  /// - Tag: PerformRequests
  func updateClassifications(for image: UIImage) {
    classificationLabel.text = "Predicting..."
    
    let orientation = CGImagePropertyOrientation(image.imageOrientation)
    guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
    
    DispatchQueue.global(qos: .userInitiated).async {
      let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
      do {
        try handler.perform([self.classificationRequest])
      } catch {
        /*
         This handler catches general image processing errors. The `classificationRequest`'s
         completion handler `processClassifications(_:error:)` catches errors specific
         to processing that request.
         */
        print("Failed to perform classification.\n\(error.localizedDescription)")
      }
    }
  }
  
  /// Updates the UI with the results of the classification.
  /// - Tag: ProcessClassifications
  func processClassifications(for request: VNRequest, error: Error?) {
    DispatchQueue.main.async {
      guard let results = request.results else {
        self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
        return
      }
      // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
      let classifications = results as! [VNClassificationObservation]
      
      if classifications.isEmpty {
        self.classificationLabel.text = "Nothing recognized."
      } else {
        self.classificationLabel.isHidden = false
        
        // Display top classifications ranked by confidence in the UI.
        let topClassifications = classifications.prefix(2)
        let shoeModel = topClassifications.map { classification in
          return String(classification.identifier)
        }
        let descriptions = topClassifications.map { classification in
          // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
          return [Double(classification.confidence)]
        }
        if shoeModel[0] == "Nike" {
          self.NikeImage.isHidden = false
          self.AdidasImage.isHidden = true
          self.UnderArmourImage.isHidden = true
          let modelConfidence = Double(descriptions[0][0])
          if modelConfidence > 0.70 {
            self.classificationLabel.text = "We're Pretty Sure These are Nike Shoes"
          }
          else{
            self.classificationLabel.text = "These Might Be Nike shoes"
          }
        }
        if shoeModel[0] == "Adidas" {
          self.AdidasImage.isHidden = false
          self.NikeImage.isHidden = true
          self.UnderArmourImage.isHidden = true
          let modelConfidence = Double(descriptions[0][0])
          if modelConfidence > 0.70 {
            self.classificationLabel.text = "We're Pretty Sure These are Adidas Shoes"
          }
          else{
            self.classificationLabel.text = "These Might Be Adidas shoes"
          }
        }
        if shoeModel[0] == "UnderArmour" {
          self.UnderArmourImage.isHidden = false
          self.NikeImage.isHidden = true
          self.AdidasImage.isHidden = true
          let modelConfidence = Double(descriptions[0][0])
          if modelConfidence > 0.70 {
            self.classificationLabel.text = "We're Pretty Sure These are UnderArmour Shoes"
          }
          else{
            self.classificationLabel.text = "These Might Be UnderArmour shoes"
          }
        }
//        self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
      }
    }
  }
  
  // MARK: - Photo Actions
  
  @IBAction func takePicture() {
    // Show options for the source picker only if the camera is available.
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      presentPhotoPicker(sourceType: .photoLibrary)
      return
    }
    
    let photoSourcePicker = UIAlertController()
    let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
      self.presentPhotoPicker(sourceType: .camera)
    }
    let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
      self.presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    photoSourcePicker.addAction(takePhoto)
    photoSourcePicker.addAction(choosePhoto)
    photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(photoSourcePicker, animated: true)
  }
  
  func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
    self.HelpLabel.isHidden = true
    self.HomePhoto.isHidden = true
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = sourceType
    present(picker, animated: true)
    
  }
  
}

extension ImageClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // MARK: - Handling Image Picker Selection
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    picker.dismiss(animated: true)
    
    // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    imageView.image = image
    classificationLabel.isHidden = false
    favoriteButton.isHidden = false
    save()
    updateClassifications(for: image)
  }
  
  func save() {
    let image = GalleryImage()
    image.name = classificationLabel.text
    image.photo = imageView.image
    print("Saving")
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
      print("Saved")
      try context.save()
    } catch {
      print("Failed saving")
    }
  }
  
  @IBAction func favorite() {
//    if favoriteButton.backgroundColor == UIColor.white {
//        favoriteButton.backgroundColor = UIColor.blue
//    }
//    else if favoriteButton.backgroundColor == UIColor.blue {
//        favoriteButton.backgroundColor = UIColor.white
//    }
    favoriteButton.isSelected.toggle()
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
  
  
  /*
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if segue.identifier == "segueName" {
   let segueName:IdentifiedController = segue.destination as! IdentifiedController
   segueName.shoeName = self.classificationLabel
   }
   }
   */
  
  /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if segue.destination is IdentifiedController {
   let segEnd = segue.destination as? IdentifiedController
   segEnd?.shoeLabel = self.classificationLabel
   }
   }*/
}
