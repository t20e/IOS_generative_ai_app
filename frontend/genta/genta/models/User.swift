//
//  User.swift
//  genta
//
//  Created by Tony Avis on 12/24/23.
//

import Foundation
import SwiftData

struct generated_imgs: Codable{
    var imgId : String
    var prompt : String
}
struct UserStruct: Codable , Identifiable{
//    since the convesion for swiftui is camelcase we can convert any snakecases that theapi sends back
    let id : String
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    let generatedImgs : [generated_imgs]
    
    
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
    let userService = UserServices()
    
    @Published var user = UserStruct(id:"", email: "", firstName: "", lastName: "", age: 2, generatedImgs: [generated_imgs(imgId: "", prompt: "")])
    
    private var token = ""
    
    init() {
//        checkToken()
    }
    
    func register(regData: RegData) async -> (err: Bool, msg: String){
            let res = await userService.regApiCall(regData: regData)
            
            if !res.err{
                isSingedIn = true
                user = res.user!
            }
            return (res.err, res.msg)
    }
    
    func login(loginData: LoginData) async -> (err: Bool, msg: String){
        //            ATTEMPT LOGIN everything passed
            //            let res = await login()
            let res = await userService.loginApiCall(loginData: loginData)
            if !res.err{
                isSingedIn = true
                user = res.user!
            }
            return (res.err, res.msg)
    }
    
    
    func checkToken() async{
        //        when the user opens the app this will run
        
        let res = KeyChainManager.get()
        if res.err{
          isSingedIn = false
//            TODO delete any tokens
        }
        let token = String(data: res.result! , encoding: .utf8)
        let data = await userService.logInUserFromToken(token: token!)
        if data.err{
//            TODO make a overlay popup that displays this
            print(data.msg)
            return
        }
        user = data.user!
        isSingedIn = true
    }
}

