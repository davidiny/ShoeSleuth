//
//  GalleryImage.swift
//  VisionSample
//
//  Created by Liz W on 11/4/19.
//  Copyright © 2019 MRM Brand Ltd. All rights reserved.
//

import Foundation
import UIKit
//THIS FILE NEEDS 100 PERCENT COVERAGE
class GalleryImage: NSObject, NSCoding {
    
    // MARK: - Properties
    var name: String?
    var favorited: Bool = false
    var photo: UIImage?
    
    // MARK: - General
    override init() {
        super.init()
    }
    
    // MARK: - Encoding
    // marking 'required' in case of subclassing, this init will be
    // required of the subclass (not really an issue here b/c not
    // subclassing; more for pedagogical purposes at this point)
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "Name") as? String
        self.favorited = aDecoder.decodeObject(forKey: "Favorited") as! Bool
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(favorited, forKey: "Favorited")
    }

}

