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

enum RegisterValidateEnum{
    case startProcess, validateEmail, validatePassword, validateConfirmPassword,  validateFirstName, validateLastName, validateAge
}
struct RegData : Codable{
    var email : String
    var password: String
    var firstName: String
    var lastName : String
    var age: Int
}


class RegLoginController : ObservableObject{
    
    let minPasswordLength = 6
    let userService = UserServices()
    var currValidatingLogin = LoginValidateEnum.startprocess
    var currValidatingReg = RegisterValidateEnum.startProcess
    
    @Published var messages : [Message] = [
        Message(text: "Prompt", sentByUser: false, isError: false),
        Message(text: "A lion walking on water", sentByUser: true, isError: false),
    ]
    @Published var actionBtnClicked = false
    @Published var currIdx = 0
    @Published var isOnSecureField = false
    @Published var currFieldPlaceholder = ""
//    bool for whether or not the user is current registering or login ing
    @Published var isCurrentlyReg : Bool = false
    @Published var inputFieldText : String = ""

    @Published var loginData = LoginData(email: "", password: "")
    @Published var regData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0)
    
    func startProcess(){
        currFieldPlaceholder = "email"
        messages.append(Message(text: "What is your email?", sentByUser: false, isError: false))
        isOnSecureField = false
        inputFieldText = ""
    }
    
    func validateRegisteration(wentBack : Bool){
        let text = inputFieldText
        if !wentBack{
            if currValidatingReg == .validatePassword || currValidatingReg == .validateConfirmPassword{
                messages.append(Message(text: String(repeating: "*", count: text.count), sentByUser: true, isError: false))
            } else if currValidatingReg != .startProcess{
                messages.append(Message(text: text, sentByUser: true, isError: false))
            }
        }
        
        switch currValidatingReg {
            case .startProcess:
                startProcess()
                currValidatingReg = .validateEmail
                isCurrentlyReg = true
                return
            case .validateEmail:
                //            TODO make sure email is not in db
                let isValidEmail = validateEmail(email: text)
                if isValidEmail{
                    regData.email = text
                    currValidatingReg = .validatePassword
                    currFieldPlaceholder = "password"
                }
                return
            case .validatePassword:
                let isValidPassword = validatePassword(password: text)
                if isValidPassword {
                    regData.password = text
                    currValidatingReg = .validateConfirmPassword
                    messages.append(Message(text: "Please confirm your password.", sentByUser: false, isError: false))
                    currFieldPlaceholder = "confirm password"
                }
                return
            case .validateConfirmPassword:
                if text != regData.password{
                    messages.append(Message(text: "Confirm Password doesn't match password.", sentByUser: false, isError: true))
                    return
                }
                messages.append(Message(text: "What is your first name?", sentByUser: false, isError: false))
                currValidatingReg = .validateFirstName
                currFieldPlaceholder = "first name"
                inputFieldText = ""
                isOnSecureField = false
                return
            case .validateFirstName:
                let isValid = validateNames(text: text)
                if isValid{
                    regData.firstName = text.lowercased()
                    currValidatingReg = .validateLastName
                    currFieldPlaceholder = "last name"
                    messages.append(Message(text: "What is your last name?", sentByUser: false, isError: false))
                }
                return
            case .validateLastName:
                let isValid = validateNames(text: text)
                if isValid{
                    regData.lastName = text.lowercased()
                    currValidatingReg = .validateAge
                    currFieldPlaceholder = "age"
                    messages.append(Message(text: "What is your age?", sentByUser: false, isError: false))
                }
                return
            case .validateAge:
                guard let age = Int(text) else{
                    return messages.append(Message(text: "Please enter a validate age", sentByUser: false, isError: true))
                }
                if age <= 13{
                    return messages.append(Message(text: "Sorry you need to be 13 or older", sentByUser: false, isError: true))
                }
        }
        messages.append(Message(text: "Registering...", sentByUser: false, isError: false))
    }
    
    func validateNames(text: String) ->  Bool {
        let regexPattern = "^[^0-9]+$"
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
            let numberOfMatches = regex.numberOfMatches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            if numberOfMatches > 0{
                inputFieldText = ""
                return true
            }else{
                messages.append(Message(text: "No numbers are allowed in names", sentByUser: false, isError: true))
                return false
            }
        }catch{
            messages.append(Message(text: "Something went wrong, please check your name", sentByUser: false, isError: true))
            return false
        }
    }
    
    func validateEmail(email: String) -> Bool{
        let res = isValidEmail(email)
        if !res{
            isOnSecureField = false
            messages.append(Message(text: "Please enter a valid email.", sentByUser: false, isError: true))
            return false
        }else{
            inputFieldText = ""
            isOnSecureField = true
            messages.append(Message(text: "Please enter a password.", sentByUser: false, isError: false))
            return true
        }
    }
    
    func validatePassword(password: String) -> Bool{
        if password.count <= 6 || password.count >= 32{
            messages.append(Message(text: "Password has to be between 6 and 32 charaters long.", sentByUser: false, isError: true))
            return false
        }
        inputFieldText = ""
        return true
    }

    func login(){
        //            ATTEMPT LOGIN everything passed
        Task{ @MainActor in
            //            let res = await login()
            let res = try await userService.loginApiCall(loginData: loginData)
            
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: true))
                currValidatingLogin = .startprocess
                validateLogin()
                return
            }
            //            else successful login
            messages.append(Message(text: res.msg, sentByUser: false, isError: false))
        }
    }

    func validateLogin(){
        let text = inputFieldText
        
        if currValidatingLogin == .validateEmail {
            messages.append(Message(text: text, sentByUser: true, isError: false))
        } else if currValidatingLogin == .validatePassword{
            messages.append(Message(text: String(repeating: "*", count: text.count), sentByUser: true, isError: false))
        }
        
        switch currValidatingLogin {
            case .startprocess:
                startProcess()
                currValidatingLogin = .validateEmail
                isCurrentlyReg = false
                return
            case .validateEmail:
            //            TODO make sure email is not in db
                let isValidEmail = validateEmail(email: text)
                if isValidEmail{
                    loginData.email = text
                    currValidatingLogin = .validatePassword
                    currFieldPlaceholder = "password"
                }
                return
            case .validatePassword:
                let isValidPassword = validatePassword(password: text)
                if isValidPassword{
                    loginData.password = text
                    messages.append(Message(text: "Logging you in.", sentByUser: false, isError: false))
                    login()
                }
        }
    }
    
    
//    func moveRegEnumBackward(currentCase: RegisterValidateEnum) -> RegisterValidateEnum? {
//        let allCases = RegisterValidateEnum.allCases
//        guard let currentIndex = allCases.firstIndex(of: currentCase) else {
//            return nil
//        }
//
//        let previousIndex = allCases.index(currentIndex, offsetBy: -2, limitedBy: allCases.startIndex)
//        return previousIndex.map { allCases[$0] }
//    }
}
