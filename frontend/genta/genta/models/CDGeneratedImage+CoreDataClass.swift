//
//  CDGeneratedImage+CoreDataClass.swift
//  Genta
//
//  Created by Tony Avis on 1/19/24.
//
//

import Foundation
import CoreData

@objc(CDGeneratedImage)
public class CDGeneratedImage: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.timestamp = Date()
    }
}
