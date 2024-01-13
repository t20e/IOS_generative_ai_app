//
//  CDUser+CoreDataProperties.swift
//  Genta
//
//  Created by Tony Avis on 1/13/24.
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
    @NSManaged public var messages_: NSOrderedSet?
    @NSManaged public var generatedImages_: NSOrderedSet?
    
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
    public var generatedImages : NSOrderedSet {
        generatedImages_ ?? []
    }
    public var messages : NSOrderedSet {
        messages_ ?? []
    }
}

// MARK: Generated accessors for messages_
extension CDUser {

    @objc(insertObject:inMessages_AtIndex:)
    @NSManaged public func insertIntoMessages_(_ value: CDMessage, at idx: Int)

    @objc(removeObjectFromMessages_AtIndex:)
    @NSManaged public func removeFromMessages_(at idx: Int)

    @objc(insertMessages_:atIndexes:)
    @NSManaged public func insertIntoMessages_(_ values: [CDMessage], at indexes: NSIndexSet)

    @objc(removeMessages_AtIndexes:)
    @NSManaged public func removeFromMessages_(at indexes: NSIndexSet)

    @objc(replaceObjectInMessages_AtIndex:withObject:)
    @NSManaged public func replaceMessages_(at idx: Int, with value: CDMessage)

    @objc(replaceMessages_AtIndexes:withMessages_:)
    @NSManaged public func replaceMessages_(at indexes: NSIndexSet, with values: [CDMessage])

    @objc(addMessages_Object:)
    @NSManaged public func addToMessages_(_ value: CDMessage)

    @objc(removeMessages_Object:)
    @NSManaged public func removeFromMessages_(_ value: CDMessage)

    @objc(addMessages_:)
    @NSManaged public func addToMessages_(_ values: NSOrderedSet)

    @objc(removeMessages_:)
    @NSManaged public func removeFromMessages_(_ values: NSOrderedSet)

}

// MARK: Generated accessors for generatedImages_
extension CDUser {

    @objc(insertObject:inGeneratedImages_AtIndex:)
    @NSManaged public func insertIntoGeneratedImages_(_ value: CDGeneratedImage, at idx: Int)

    @objc(removeObjectFromGeneratedImages_AtIndex:)
    @NSManaged public func removeFromGeneratedImages_(at idx: Int)

    @objc(insertGeneratedImages_:atIndexes:)
    @NSManaged public func insertIntoGeneratedImages_(_ values: [CDGeneratedImage], at indexes: NSIndexSet)

    @objc(removeGeneratedImages_AtIndexes:)
    @NSManaged public func removeFromGeneratedImages_(at indexes: NSIndexSet)

    @objc(replaceObjectInGeneratedImages_AtIndex:withObject:)
    @NSManaged public func replaceGeneratedImages_(at idx: Int, with value: CDGeneratedImage)

    @objc(replaceGeneratedImages_AtIndexes:withGeneratedImages_:)
    @NSManaged public func replaceGeneratedImages_(at indexes: NSIndexSet, with values: [CDGeneratedImage])

    @objc(addGeneratedImages_Object:)
    @NSManaged public func addToGeneratedImages_(_ value: CDGeneratedImage)

    @objc(removeGeneratedImages_Object:)
    @NSManaged public func removeFromGeneratedImages_(_ value: CDGeneratedImage)

    @objc(addGeneratedImages_:)
    @NSManaged public func addToGeneratedImages_(_ values: NSOrderedSet)

    @objc(removeGeneratedImages_:)
    @NSManaged public func removeFromGeneratedImages_(_ values: NSOrderedSet)

}

extension CDUser : Identifiable {

}
