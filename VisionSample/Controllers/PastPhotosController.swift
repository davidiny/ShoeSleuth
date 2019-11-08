//
//  PastPhotosController.swift
//  VisionSample
//
//  Created by David Inyangson on 11/7/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class PastPhotosController: UIViewController{
  
  
  @IBOutlet var collectionsView: UICollectionView!


  private let dataSource = CustomDataSource()

  
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Set the collection view's data source.
      collectionsView.dataSource = dataSource
    
      // Set the collection view's prefetching data source.
      collectionsView.prefetchDataSource = dataSource
    
      // Add a border to the collection view's layer so its edges are visible.
      collectionsView.layer.borderColor = UIColor.black.cgColor
  }
  

    
  

}
