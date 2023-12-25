//
//  LoginController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation
import SwiftUI

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


class OnBoardingViewController : ObservableObject{
    
    let minPasswordLength = 6
    let maxPasswordLength = 32
    var currValidatingLogin = LoginValidateEnum.startprocess
    var currValidatingReg = RegisterValidateEnum.startProcess
    @Published var canLogin = false
    @Published var canReg = false
    @Published var canCheckIfEmailExists = false
    @Published var actionBtnClicked = false
    @Published var currIdx = 0
    @Published var isOnSecureField = false
    @Published var currFieldPlaceholder = ""
//    bool for whether or not the user is current registering or login ing
    @Published var isCurrentlyReg : Bool = false
    @Published var inputFieldText : String = ""

    @Published var loginData = LoginData(email: "", password: "")
    @Published var regData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0)
    
    @Published var messages : [Message] = [
        Message(text: "Prompt?", sentByUser: false),
        Message(text: "A lion walking on water", sentByUser: true), //TODO ADD IMAGE AND PROMPT
        Message(text: "", sentByUser: false, isImg: true, image: Image("test_img"))
    ]
    
    func startProcess(){
        currFieldPlaceholder = "email"
        messages.append(Message(text: "What is your email?", sentByUser: false))
        isOnSecureField = false
        inputFieldText = ""
    }
    
    
    func validateRegisteration(wentBack : Bool){
        let text = inputFieldText
        if !wentBack{
            if currValidatingReg == .validatePassword || currValidatingReg == .validateConfirmPassword{
                messages.append(Message(text: String(repeating: "*", count: text.count), sentByUser: true))
            } else if currValidatingReg != .startProcess{
                messages.append(Message(text: text, sentByUser: true))
            }
        }
        
        switch currValidatingReg {
            case .startProcess:
                startProcess()
                currValidatingReg = .validateEmail
                isCurrentlyReg = true
                return
            case .validateEmail:
                    canCheckIfEmailExists = true
                return
            case .validatePassword:
                let isValidPassword = validatePassword(password: text)
                if isValidPassword {
                    regData.password = text
                    currValidatingReg = .validateConfirmPassword
                    messages.append(Message(text: "Please confirm your password.", sentByUser: false))
                    currFieldPlaceholder = "confirm password"
                }
                return
            case .validateConfirmPassword:
                if text != regData.password{
                    messages.append(Message(text: "Confirm Password doesn't match password.", sentByUser: false, isError: true))
                    return
                }
                messages.append(Message(text: "What is your first name?", sentByUser: false))
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
                    messages.append(Message(text: "What is your last name?", sentByUser: false))
                }
                return
            case .validateLastName:
                let isValid = validateNames(text: text)
                if isValid{
                    regData.lastName = text.lowercased()
                    currValidatingReg = .validateAge
                    currFieldPlaceholder = "age"
                    messages.append(Message(text: "What is your age?", sentByUser: false))
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
        messages.append(Message(text: "Registering...", sentByUser: false, isLoadingSign: true))
        canReg = true
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
    
    func validatePassword(password: String) -> Bool{
        if password.count <= minPasswordLength || password.count >= maxPasswordLength{
            messages.append(Message(text: "Password has to be between 6 and 32 charaters long.", sentByUser: false, isError: true))
            return false
        }
        inputFieldText = ""
        return true
    }

    func validateLogin(){
        let text = inputFieldText
        
        if currValidatingLogin == .validateEmail {
            messages.append(Message(text: text, sentByUser: true))
        } else if currValidatingLogin == .validatePassword{
            messages.append(Message(text: String(repeating: "*", count: text.count), sentByUser: true))
        }
        
        switch currValidatingLogin {
            case .startprocess:
                startProcess()
                currValidatingLogin = .validateEmail
                isCurrentlyReg = false
                return
            case .validateEmail:
                loginData.email = text
                currValidatingLogin = .validatePassword
                currFieldPlaceholder = "password"
                inputFieldText = ""
                isOnSecureField = true
                messages.append(Message(text: "Please enter a password.", sentByUser: false))
                return
            case .validatePassword:
                let isValidPassword = validatePassword(password: text)
                if isValidPassword{
                    loginData.password = text
                    messages.append(Message(text: "Logging in...", sentByUser: false, isLoadingSign: true))
//                    login()
                    canLogin = true
                }
        }
    }
    
    
    func goBackward(){
        if isCurrentlyReg{
            regGoBackward()
        }else{
            loginGoBackward()
        }
    }
    
    func switchTo(){
//        switches between login and registration
        if isCurrentlyReg {
//            switch to login
            messages.append(Message(text: "Logging in instead", sentByUser: false))
            isCurrentlyReg = false
            currValidatingLogin = .startprocess
            validateLogin()
        } else {
            messages.append(Message(text: "Signing up instead", sentByUser: false))
            isCurrentlyReg = true
            currValidatingReg = .startProcess
            validateRegisteration(wentBack: false)
        }
    }
    
    func loginGoBackward(){
        if currValidatingLogin == .validatePassword  {
            currValidatingLogin = .startprocess
            isOnSecureField = false
            validateLogin()
        }else{
            messages.append(Message(text: "Sorry cant go backward", sentByUser: false, isError: true))
        }
    }
    
    func regGoBackward(){
        switch currValidatingReg{
//            moves backward from whatever it is currently validatation
            case .startProcess:
//                messages.append(Message(text: "Sorry cant go backward", sentByUser: false))
                return
            case .validateEmail:
                messages.append(Message(text: "Sorry cant go backward", sentByUser: false, isError: true))
                return
            case .validatePassword:
                inputFieldText = ""
                currValidatingReg = .startProcess
            case .validateConfirmPassword:
                inputFieldText = regData.email
                currValidatingReg = .validateEmail
            case .validateFirstName:
                inputFieldText = regData.password
                currValidatingReg = .validatePassword
            case .validateLastName:
            inputFieldText = regData.password
                currValidatingReg = .validateConfirmPassword
            case .validateAge:
            inputFieldText = regData.firstName
                currValidatingReg = .validateFirstName
            }
            validateRegisteration(wentBack: true)
    }
}
