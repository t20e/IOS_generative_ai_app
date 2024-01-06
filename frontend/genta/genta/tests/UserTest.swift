//
//  UserTest.swift
//  genta
//
//  Created by Tony Avis on 1/5/24.
//

import Foundation
import SwiftData

@Model
class UserTest : Identifiable{
    //    since the convesion for swiftui is camelcase we can convert any snakecases that theapi sends back
    let id : String
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    var numOfImgsGenerated : Int
    var generatedImgs : [GeneratedImgsStruct]
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id" //turn the _id from mongoDB into a id so struct can be identifiable everything else gets converted from first_name to firstName becuase of     decoder.keyDecodingStrategy = .convertFromSnakeCase just the _id wasnt working with that
        case email
        case firstName
        case lastName
        case age
        case generatedImgs
        case numOfImgsGenerated
    }
    
    init(id: String, email: String, firstName: String, lastName: String, age: Int, numOfImgsGenerated: Int, generatedImgs: [GeneratedImgsStruct]) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.numOfImgsGenerated = numOfImgsGenerated
        self.generatedImgs = generatedImgs
    }
}
