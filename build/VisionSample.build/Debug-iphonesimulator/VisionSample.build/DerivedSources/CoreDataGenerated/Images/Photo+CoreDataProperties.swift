//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Liz W on 12/10/19.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var favorited: Bool
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?

}
