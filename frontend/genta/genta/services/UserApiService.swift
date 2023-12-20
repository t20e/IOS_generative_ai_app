//
//  UserApiService.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import SwiftUI

struct generated_imgs: Codable{
    var imgId : String
    var prompt : String
}

struct UserApi: Codable{
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    let generatedImgs : [generated_imgs]
}

struct UserApiService: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    UserApiService()
}
