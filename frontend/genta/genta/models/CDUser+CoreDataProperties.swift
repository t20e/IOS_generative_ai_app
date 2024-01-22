//
//  CDUser+CoreDataProperties.swift
//  Genta
//
//  Created by Tony Avis on 1/21/24.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var accessToken_: String?
    @NSManaged public var age_: Int64
    @NSManaged public var email_: String?
    @NSManaged public var firstName_: String?
    @NSManaged public var id_: String?
    @NSManaged public var isCurrUser_: Bool
    @NSManaged public var lastName_: String?
    @NSManaged public var numImgsGenerated_: Int64
    @NSManaged public var generatedImages_: NSSet?
    @NSManaged public var messages_: NSSet?

    // - Mark to not have to deal with optionals we can do the following
    public var accesToken : String {
        accessToken_ ?? ""
    }
    public var email : String {
        email_ ?? ""
    }
    public var firstName : String {
        firstName_ ?? ""
    }
    public var id : String {
        id_ ?? ""
    }
    public var lastName : String {
        lastName_ ?? ""
    }
    public var generatedImages : NSSet {
        generatedImages_ ?? []
    }
    public var messages : NSSet {
        messages_ ?? []
    }
    public var accessToken : String{
        accessToken_ ?? ""
    }
    
}

// MARK: Generated accessors for generatedImages_
extension CDUser {

    @objc(addGeneratedImages_Object:)
    @NSManaged public func addToGeneratedImages_(_ value: CDGeneratedImage)

    @objc(removeGeneratedImages_Object:)
    @NSManaged public func removeFromGeneratedImages_(_ value: CDGeneratedImage)

    @objc(addGeneratedImages_:)
    @NSManaged public func addToGeneratedImages_(_ values: NSSet)

    @objc(removeGeneratedImages_:)
    @NSManaged public func removeFromGeneratedImages_(_ values: NSSet)

}

// MARK: Generated accessors for messages_
extension CDUser {

    @objc(addMessages_Object:)
    @NSManaged public func addToMessages_(_ value: CDMessage)

    @objc(removeMessages_Object:)
    @NSManaged public func removeFromMessages_(_ value: CDMessage)

    @objc(addMessages_:)
    @NSManaged public func addToMessages_(_ values: NSSet)

    @objc(removeMessages_:)
    @NSManaged public func removeFromMessages_(_ values: NSSet)

}

extension CDUser : Identifiable {

}
