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

struct RegData : Codable{
    var email : String
    var password: String
    var firstName: String
    var lastName : String
    var age: Int
}

enum LoginValidateEnum {
    case validateEmail, validatePassword
}

enum RegisterValidateEnum{
    case validateEmail, validateCode, validatePassword, validateConfirmPassword,  validateFirstName, validateLastName, validateAge
}



class LoginRegController : ObservableObject{
        
    let minPasswordLength = 6
    let maxPasswordLength = 32
    
    @Published var loginProcess = LoginValidateEnum.validateEmail
    @Published var regProcess = RegisterValidateEnum.validateEmail
    @Published var placeholder = "email"

    @Published var loginData = LoginData(email: "", password: "")
    @Published var regData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0)
    
    
    var exampleGeneratedImages =  [
        [
            "prompt": "Design a captivating image of a city in the future, featuring towering skyscrapers made of gleaming glass and steel structures. The city should have flying cars and monorail systems zipping through the sky. There should be rooftop gardens on some buildings, demonstrating city dwellers' commitment to urban green spaces.",
            "imageName": "Design_a_captivating_image_of_a_city_in_the_future,"
        ],
        [
            "prompt": "Create an image comprising abstract geometric patterns. These patterns should take various forms such as squares, triangles, circles, and polygons, among others.",
            "imageName": "abstractGeometricPattern"
        ],
        [
            "prompt": "Imagine a scene in a cloudy sky, filled with intricately designed flying machines inspired by the steampunk aesthetic.",
            "imageName": "steamPunk"
        ],
        [
            "prompt": "Imagine a whimsical scene set in a well-maintained garden full of flowers and lush greenery. In this garden, there is an unusual, joyful gathering taking place. A troupe of quirky robots, all of different shapes, sizes and colors, are happily engaged in a tea party.",
            "imageName": "robotsDiner"
        ]
    ]
    
    
    func switchTo(isOnLogin : Bool) -> Message{
//        switches between login and registration
        if isOnLogin {
            loginProcess = .validateEmail
            regProcess = .validateEmail
            return Message(text: "Signing up instead, Enter your email.", sentByUser: false)
        } else {
//            switch to login
            loginProcess = .validateEmail
            return Message(text: "Logging in instead, Enter your email.", sentByUser: false)
        }
    }
    
    func validateLogin(text : String) -> (err:Bool, msg : Message){
        switch loginProcess{
            case .validateEmail:
                loginData.email = text
                placeholder = "password"
                loginProcess = .validatePassword
                return (false, Message(text: "Please enter a password.", sentByUser: false))
            default:
                return (true, Message(text: "Something went wrong, please refresh app!", sentByUser: false, isLoadingSign: true))
                }
    }

    func validateReg(text : String) ->  (err: Bool, msg : Message){
        switch regProcess {
            case .validatePassword:
                if text.count < minPasswordLength || text.count >= maxPasswordLength{
                    return (true, Message(text: "Password has to be between 6 and 32 charaters long.", sentByUser: false, isError: true))
                }
                regData.password = text.trimmingCharacters(in: .whitespacesAndNewlines)
                regProcess = .validateConfirmPassword
                placeholder = "confirm password"
                return (false, Message(text: "Confirm your password.", sentByUser: false))
            case .validateConfirmPassword:
                if text != regData.password{
                    return (true, Message(text: "Confirm Password doesn't match password.", sentByUser: false, isError: true))
                }
                regProcess = .validateFirstName
                placeholder = "first name"
                return (false, Message(text: "What is your first name?", sentByUser: false))
            case .validateFirstName:
                let isValid = validateNames(text: text)
                if isValid.err {
                    return (true, Message(text: isValid.msg, sentByUser: false, isError: true))
                }
                regData.firstName = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                regProcess = .validateLastName
                placeholder = "last name"
                return (false, Message(text: "What is your last name?", sentByUser: false))
            
            case .validateLastName:
                let isValid = validateNames(text: text)
                if isValid.err{
                    return (true, Message(text: isValid.msg, sentByUser: false, isError: true))
                }
                regData.lastName = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                regProcess = .validateAge
                placeholder = "age"
                return (false, Message(text: "What is your age?", sentByUser: false))
            default:
                return (true, Message(text: "Something went wrong, please refresh app!", sentByUser: false, isLoadingSign: true))
        }
    }

    func regGoBackward() ->  Message{
        switch regProcess{
            case .validateEmail:
                return(Message(text: "Cant go backward", sentByUser: false, isError: true))
            case .validateCode:
                regProcess = .validateEmail
                return Message(text: "Enter email.", sentByUser: false)
            case .validatePassword:
                regProcess = .validateEmail
                return Message(text: "Enter your email.", sentByUser: false)
            case .validateConfirmPassword:
                regProcess = .validatePassword
                return Message(text: "Enter a password.", sentByUser: false)
            case .validateFirstName:
                regProcess = .validatePassword
                return Message(text: "Enter a password.", sentByUser: false)
            case .validateLastName:
                regProcess = .validateFirstName
                return Message(text: "What is your first name?", sentByUser: false)
            case .validateAge:
                regProcess = .validateLastName
                return Message(text: "What is your last name?", sentByUser: false)
            }
    }  
    
}
