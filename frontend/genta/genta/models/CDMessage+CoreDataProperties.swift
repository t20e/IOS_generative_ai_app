//
//  CDMessage+CoreDataProperties.swift
//  Genta
//
//  Created by Tony Avis on 1/19/24.
//
//

import Foundation
import CoreData



extension CDMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMessage> {
        return NSFetchRequest<CDMessage>(entityName: "CDMessage")
    }

    @NSManaged public var alreadyAnimated: Bool
    @NSManaged public var id: UUID
    @NSManaged public var imageData_: Data?
    @NSManaged public var isError: Bool
    @NSManaged public var isImg: Bool
    @NSManaged public var isLoadingSign: Bool
    @NSManaged public var isRevisedPrompt: Bool
    @NSManaged public var sentByUser: Bool
    @NSManaged public var text_: String?
    @NSManaged public var timestamp: Date
    @NSManaged public var cduser: CDUser?

    public var imageData : Data{
        imageData_ ?? Data()
    }
    public var text : String{
        text_ ?? ""
    }
}

extension CDMessage : Identifiable {

}
