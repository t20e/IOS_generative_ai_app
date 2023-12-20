//
//  RegController.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation

//struct RegData{
//    var email: String
//    var password: String
//    var confirmPassword: String
//}
//@Published var regData = LoginData(email: "", password: "", confirmPassword: "")


class RegController : ObservableObject{
    var currIdx = 0
    init() {}
    
    @Published var regMsgsHolder : [Message] = [
        Message(text: "What is your email?", sentByUser: false),
        Message(text: "What is your password?", sentByUser: false),
    ]
    
    func register(text:String){
        print("registering")
//        if currIdx == 0{
//            return ""
//        }
    }
    
}
