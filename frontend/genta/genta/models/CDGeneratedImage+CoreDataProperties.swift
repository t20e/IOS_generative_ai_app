//
//  CDGeneratedImage+CoreDataProperties.swift
//  Genta
//
//  Created by Tony Avis on 1/19/24.
//
//

import Foundation
import CoreData


extension CDGeneratedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGeneratedImage> {
        return NSFetchRequest<CDGeneratedImage>(entityName: "CDGeneratedImage")
    }

    @NSManaged public var data_: Data?
    @NSManaged public var imgId: String
    @NSManaged public var presignedUrl: String
    @NSManaged public var prompt: String
    @NSManaged public var timestamp: Date
    @NSManaged public var cduser: CDUser?

}

extension CDGeneratedImage : Identifiable {

}


