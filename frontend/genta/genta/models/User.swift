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

struct UserData: Codable , Identifiable{
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
}

// I tried to make it more DRY but decoding incoming user data into a class but than the class wouldnt conform to codable
@MainActor class User : ObservableObject{
    
    @Published var isSingedIn = false
    //    @Published var tokenExpired = false
    
    let userService = UserServices()
    let imageServices = ImageServices()
    
    @Published var data = UserData(id:"", email: "", firstName: "", lastName: "", age: 0, numOfImgsGenerated: 0, generatedImgs: [])
    
    private var tokenAccess = ""
    
    init() {    }
    
    func register(regData: RegData) async -> (err: Bool, msg: String){
        let res = await userService.regApiCall(regData: regData)
        
        if !res.err{
            isSingedIn = true
            data = res.user!
            let getToken = KeyChainManager.get()
            if getToken.err{
                return(true, "Something went wrong! Please log back in")
            }
            tokenAccess = String(data: getToken.result!, encoding: .utf8)!
            return(false, "Successfully registered")
        }
        return (res.err, res.msg)
    }
    
    func login(loginData: LoginData) async -> (err: Bool, msg: String){
        let res = await userService.loginApiCall(loginData: loginData)
        if !res.err{
            isSingedIn = true
            data = res.user!
            let getToken = KeyChainManager.get()
            if getToken.err{
                return(true, "Something went wrong! Please log back in")
            }
            tokenAccess = String(data: getToken.result!, encoding: .utf8)!
            
            await addManyImages()
            return (false, "Successfully logged in")
        }
        return (res.err, res.msg)
    }
    
    
    func checkToken() async -> Bool {
        // when the user opens the app this will run
        // return true if successful in loggin user in from token or not
        let foundToken = KeyChainManager.search()
        if foundToken{
            //            attempt to log in the user with the token
            let getToken = KeyChainManager.get()
            let token = String(data: getToken.result! , encoding: .utf8)
            let res = await userService.logInUserFromToken(token: token!)
            if res.err{
                // if the token expired alert the user that their session expire and log back in
                //                tokenExpired = true
                let deleteRes = KeyChainManager.delete()
                if deleteRes{
                    isSingedIn = false
                    return false
                }else{
                    print("Error deleting token when attempting to log user in from token")
                }
            }
            tokenAccess = token!
            isSingedIn = true
            data = res.user!
//            print(data)
            await addManyImages()
            return true
        }
        isSingedIn = false
        return false
    }
    
    func addManyImages() async{
        /*
         gets the image data from ImageServices and add that data to users generated images
         
         gets all the user's images data from the generatedImages array and foreach image it will call downloadImage and set
         the data field to the downloaded image as a Data obj
         */
        for idx in data.generatedImgs.indices {
            await addOneImage(idx: idx)
        }
    }
    
    
    func addOneImage(idx : Int) async{
        /*
         this will add the missing data field form generatedImgs and using the presignedUrl it will fill that data
         */
        let url = data.generatedImgs[idx].presignedUrl
        let res = await imageServices.downLoadImage(presignedUrl: url)
        
        if res != nil{
            data.generatedImgs[idx].data = res
        }else{
//            TODO do something cuz error
            print("Issue with getting data object from ImageServices.downloadImage")
        }
        
        
    }
    
    func getAccessToken() -> String{
        return tokenAccess
    }
    
    func logout(){
        let isSuccess = KeyChainManager.delete()
        if isSuccess{
            data = UserData(id: "", email: "", firstName: "", lastName: "", age: 0, numOfImgsGenerated: 0, generatedImgs: [])
            isSingedIn = false
        }
//        alert user something went wrong
    }
}

