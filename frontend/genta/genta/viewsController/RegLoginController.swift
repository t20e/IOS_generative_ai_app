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
    
    @Published var messages : [Message] = [
        Message(text: "Prompt", sentByUser: false),
        Message(text: "A lion walking on water", sentByUser: true),
    ]
    @Published var actionBtnClicked = false
    @Published var currIdx = 0
    @Published var isOnSecureField = false
    @Published var currFieldPlaceholder = "email"
//    bool for whether or not the user is current registering or login ing
    @Published var isCurrentlyReg : Bool = false
    @Published var inputFieldText : String = ""

    @Published var loginData = LoginData(email: "", password: "")

//    private func login() async -> (err : Bool, msg : String){
//        Task{
//            let res = try await userService.loginApiCall(loginData: loginData)
//            }
//        }
//    
//    }
    

    func validateLogin(){
        let text = inputFieldText
        switch currentlyValidating {
            case .startprocess:
                currentlyValidating = .validateEmail
                messages.append(Message(text: "What is your email?", sentByUser: false))
                isOnSecureField = false
                isCurrentlyReg = false
                inputFieldText = ""
                return
            case .validateEmail:
                let res = isValidEmail(text)
                if !res{
                    isOnSecureField = false
                    messages += [Message(text: text, sentByUser: true), Message(text: "Please enter a valid email.", sentByUser: false)]
                    return
                }
                inputFieldText = ""
                loginData.email = text
                currentlyValidating = .validatePassword
                messages += [Message(text: text, sentByUser: true), Message(text: "What is your password.", sentByUser: false)]
                return
            case .validatePassword:
                if text.count <= 6 || text.count >= 32{
                    messages += [Message(text: String(repeating: "*", count: text.count), sentByUser: true), Message(text: "Password has to be between 6 and 32 charaters long.", sentByUser: false)]
                    return
                }
                inputFieldText = ""
                loginData.password = text
                }
                //            ATTEMPT LOGIN everything passed
                messages += [Message(text: String(repeating: "*", count: text.count), sentByUser: true), Message(text: "Logging you in.", sentByUser: false)]
                Task{ @MainActor in
        //            let res = await login()
                    let res = try await userService.loginApiCall(loginData: loginData)
                    
                    if res.err{
                        messages += [ Message(text: res.msg, sentByUser: false)]
                        currentlyValidating = .startprocess
                        validateLogin()
                        return
                    }
        //            else successful login
                    messages += [ Message(text: res.msg, sentByUser: false)]
        }
    }
    
    func loginGoBackward() -> Bool{
        if currentlyValidating == .validatePassword  {
            currentlyValidating = .startprocess
            return true
        }
        return false
    }
    
}
