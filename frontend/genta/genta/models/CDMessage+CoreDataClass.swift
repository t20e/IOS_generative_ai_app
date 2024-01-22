//
//  CDMessage+CoreDataClass.swift
//  Genta
//
//  Created by Tony Avis on 1/21/24.
//
//

import Foundation
import CoreData

@objc(CDMessage)
public class CDMessage: NSManagedObject {
    override public func awakeFromInsert() {
        // on creation add a timestamp
        super.awakeFromInsert()
        self.timestamp = Date()
    }
}
