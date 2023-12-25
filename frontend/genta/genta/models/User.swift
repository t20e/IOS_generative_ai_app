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

@MainActor class User : ObservableObject{
    
    @Published var isSingedIn = false
    let userService = UserServices()
    
    @Published var user = UserStruct(email: "", firstName: "", lastName: "", age: 2, generatedImgs: [generated_imgs(imgId: "", prompt: "")])

    
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
    
}

