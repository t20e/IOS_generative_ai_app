//
//  LoginController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation


struct LoginData : Codable{
    var email: String
    var password: String
}

struct LoginToIntroControllerMsg{
    var err: Bool
    var msg : String
    var isNextFieldSecure: Bool
}

enum LoginValidateEnum {
    case startprocess, validateEmail, validatePassword
}


class RegLoginController : ObservableObject{
    let minPasswordLength = 6
    let userService = UserServices()
    var currentlyValidating = LoginValidateEnum.startprocess

    @Published var loginData = LoginData(email: "", password: "")

//    private func login() async -> (err : Bool, msg : String){
//        Task{
//            let res = try await userService.loginApiCall(loginData: loginData)
//            }
//        }
//    
//    }
    
    func validateLogin(text: String) -> (LoginToIntroControllerMsg, Message){
        switch currentlyValidating {
            case .startprocess:
                currentlyValidating = .validateEmail
                return (LoginToIntroControllerMsg(err: false, msg: "What is your email?", isNextFieldSecure: false), Message(text: "", sentByUser: false))
            case .validateEmail:
                let res = isValidEmail(text)
                if !res{
                    return (LoginToIntroControllerMsg(err: true, msg: "Please enter a valid email.", isNextFieldSecure: false), Message(text: text, sentByUser: true))
                }
                loginData.email = text
                currentlyValidating = .validatePassword
                return (LoginToIntroControllerMsg(err: false, msg: "What is your password.", isNextFieldSecure: true), Message(text: text, sentByUser: true))
            case .validatePassword:
                if text.count <= 6 || text.count >= 32{
                    return (LoginToIntroControllerMsg(err: true, msg: "Password has to be between 6 and 32 charaters long.", isNextFieldSecure: true), Message(text: String(repeating: "*", count: text.count), sentByUser: true))
                }
                loginData.password = text
                }
        //            ATTEMPT LOGIN everything passed
        Task{
//            let res = await login()
            let res = try await userService.loginApiCall(loginData: loginData)
            
            if res.err{
                return (LoginToIntroControllerMsg(err: res.err, msg: res.msg, isNextFieldSecure: true), Message(text: String(repeating: "*", count: text.count), sentByUser: true))
            }
//            else successful login
            return (LoginToIntroControllerMsg(err: false, msg: res.msg, isNextFieldSecure: false), Message(text: String(repeating: "*", count: text.count), sentByUser: true))
        }
        return (LoginToIntroControllerMsg(err: false, msg: "Logging you in.", isNextFieldSecure: false), Message(text: String(repeating: "*", count: text.count), sentByUser: true))
    }
    
    func loginGoBackward() -> Bool{
        if currentlyValidating == .validatePassword  {
            currentlyValidating = .startprocess
            return true
        }
        return false
    }
}
