//
//  CDGeneratedImage+CoreDataProperties.swift
//  Genta
//
//  Created by Tony Avis on 1/13/24.
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
    @NSManaged public var cduser: CDUser?
    
    public var data : Data{
        data_ ?? Data()
    }
    
}

extension CDGeneratedImage : Identifiable {

}
