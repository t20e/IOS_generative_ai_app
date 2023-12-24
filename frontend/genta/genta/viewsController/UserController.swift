//
//  User.swift
//  genta
//
//  Created by Tony Avis on 12/24/23.
//

import Foundation


struct generated_imgs: Codable{
    var imgId : String
    var prompt : String
}

struct UserStruct: Codable{
//    since the convesion for swiftui is camelcase we can convert any snakecases that theapi sends back
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    let generatedImgs : [generated_imgs]
}

class User : ObservableObject{
    
    @Published var isSingedIn = false
    
    init(){}
}
