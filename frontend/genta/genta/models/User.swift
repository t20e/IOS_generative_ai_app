//
//  User.swift
//  genta
//
//  Created by Tony Avis on 12/24/23.
//

import Foundation
import SwiftUI
import UIKit

struct GeneratedImgsStruct: Codable{
    var imgId: String
    var prompt: String
    var presignedUrl: String
    var imageData: String? // store image as string of base64

    mutating func loadUIImage() {
        self.imageData = ""
    }
}

struct UserStruct: Codable , Identifiable{
//    since the convesion for swiftui is camelcase we can convert any snakecases that theapi sends back
    let id : String
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    let generatedImgs : [GeneratedImgsStruct]
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id" //turn the id from mongoDB into a id so struct can be identifiable
//        everything else gets converted from first_name to firstName becuase of     decoder.keyDecodingStrategy = .convertFromSnakeCase just the _id wasnt working with that
        case email
        case firstName
        case lastName
        case age
        case generatedImgs
    }
}

@MainActor class User : ObservableObject{
    
    @Published var isSingedIn = false
    @Published var tokenExpired = false
    
    let userService = UserServices()
    
    @Published var data = UserStruct(id:"", email: "", firstName: "", lastName: "", age: 2, generatedImgs: [GeneratedImgsStruct(imgId: "", prompt: "", presignedUrl: "")])
    
    private var tokenAccess = ""
    
    init() {    }
    
    func register(regData: RegData) async -> (err: Bool, msg: String){
            let res = await userService.regApiCall(regData: regData)
            
            if !res.err{
                isSingedIn = true
                data = res.user!
            }
            return (res.err, res.msg)
    }
    
    func login(loginData: LoginData) async -> (err: Bool, msg: String){
        //            ATTEMPT LOGIN everything passed
            //            let res = await login()
            let res = await userService.loginApiCall(loginData: loginData)
            if !res.err{
                isSingedIn = true
                data = res.user!
            }
            return (res.err, res.msg)
    }
    
    
    func checkToken() async{
        //        when the user opens the app this will run
        let foundToken = KeyChainManager.search()
        if foundToken{
//            attempt to log in the user with the token
            let getToken = KeyChainManager.get()
            let token = String(data: getToken.result! , encoding: .utf8)
            let res = await userService.logInUserFromToken(token: token!)
            if res.err{
                // if the token expired alert the user that their session expire and log back in
                tokenExpired = true
                return isSingedIn = false
            }
            tokenAccess = token!
            isSingedIn = true
            data = res.user!
            print("here", data.generatedImgs)
//            print("\n\n user here", data)
            return
        }
        isSingedIn = false
    }
}

