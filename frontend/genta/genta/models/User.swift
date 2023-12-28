//
//  User.swift
//  genta
//
//  Created by Tony Avis on 12/24/23.
//

import Foundation
import SwiftUI
import UIKit

struct GeneratedImgsStruct: Codable, Hashable{
    var imgId: String
    var prompt: String
    var presignedUrl: String
    var data : Data? // store image as string of base64 i coulnt just leave it a uiImage becuase uiimage doesnt conform to codable
    
}

struct UserStruct: Codable , Identifiable{
//    since the convesion for swiftui is camelcase we can convert any snakecases that theapi sends back
    let id : String
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    var generatedImgs : [GeneratedImgsStruct]
    
    
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
    
//    @Published var data:
    @Published var data = UserStruct(id:"", email: "", firstName: "", lastName: "", age: 2, generatedImgs: [])

    
    private var tokenAccess = ""
    
    init() {    }
    
    func register(regData: RegData) async -> (err: Bool, msg: String){
            let res = await userService.regApiCall(regData: regData)
            
            if !res.err{
                isSingedIn = true
                data = res.user!
                await addImgDataToUser()
                return(false, "Successfully registered")
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
                await addImgDataToUser()
                return (false, "Successfully logged in")
            }
            return (res.err, res.msg)
    }
    
    
    func checkToken() async {
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
            await addImgDataToUser()
            return
        }
        isSingedIn = false
    }
    
    func addImgDataToUser() async{
        /*
         get the image data from ImageServices and add that data to users generated images
         */
//        data.generatedImgs.forEach({idx in
//            idx.prompt = "HELOLO"
//        })
        for idx in data.generatedImgs.indices {
            let url = data.generatedImgs[idx].presignedUrl
            let res = await ImageServices.downLoadImage(presignedUrl: url)
            
            if res != nil{
                data.generatedImgs[idx].data = res
            }else{
                print("Issue with getting data object from ImageServices.downloadImage")
            }
        }
    }
    
}

