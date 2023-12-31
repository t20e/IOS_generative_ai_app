//
//  OnBoardingViewModel.swift
//  genta
//
//  Created by Tony Avis on 1/6/24.
//

import Foundation
import SwiftData
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

enum ExecuteProcess{
    case none, register, login
}


@MainActor
class OnBoardingViewModel : ObservableObject{
    
    let minPasswordLength = 6
    let maxPasswordLength = 32
    
    @Published var executeProcess  = ExecuteProcess.none
    @Published var loginProcess = LoginValidateEnum.validateEmail
    @Published var regProcess = RegisterValidateEnum.validateEmail
    @Published var placeholder = "email"
    
    @Published var loginData = LoginData(email: "", password: "")
    @Published var regData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0)
    @Published var messages : [Message] = []
    @Published var isOnLogin = false
    @Published var showRegLogin = false
    @Published var textInput = ""
    @Published var canAnimateLoading = false
    
    init(loginProcess: LoginValidateEnum = LoginValidateEnum.validateEmail, regProcess: RegisterValidateEnum = RegisterValidateEnum.validateEmail, placeholder: String = "email", loginData: LoginData = LoginData(email: "", password: ""), regData: RegData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0), isOnLogin: Bool = false, showRegLogin: Bool = false, messages: [Message] = [], textInput: String = "", canAnimateLoading: Bool = false) {
        self.loginProcess = loginProcess
        self.regProcess = regProcess
        self.placeholder = placeholder
        self.loginData = loginData
        self.regData = regData
        self.isOnLogin = isOnLogin
        self.showRegLogin = showRegLogin
        self.messages = messages
        self.textInput = textInput
        self.canAnimateLoading = canAnimateLoading
        self.setStartingMsg()
    }
    
    func forward_propagate(){
        if textInput.count < 2 {
            messages.append(Message(text: "Please enter something.", sentByUser: false, isError: true, imageData: nil))
            return
        }
        if regProcess == .validatePassword || regProcess == .validateConfirmPassword ||
            // append the passwords as **** to messages
            loginProcess == .validatePassword || regProcess == .validateCode {
            messages.append(Message(text: String(repeating: "*", count: textInput.count), sentByUser: true, imageData: nil))
        }else{ //append whatever the user wrote as text not ***
            messages.append(Message(text: textInput, sentByUser: true, imageData: nil))
        }
        //validte login and registeration
        if isOnLogin{
            validateLogin()
        } else {
            validateReg()
        }
    }
    
    func startLoadingAnimation(){
        //starts the loading animation on messages
        canAnimateLoading = true
    }
 
    func stopAnimation() async {
        //stops the loading animation on messages
        await delay(seconds: 2.0)
        removeLoadingLastIndex()
        canAnimateLoading = false
        
    }
    
    func removeLoadingLastIndex(){
        //        removes the loading sign of the last index of the messages array
        if let lastIndex = messages.indices.last {
            // Update the last item
            messages[lastIndex].isLoadingSign = false
        }
    }
    
    
    //    TODO when err occurs remove the loading sign
    func validateLogin(){
        let text = textInput
        switch loginProcess{
        case .validateEmail:
            loginData.email = text
            placeholder = "password"
            loginProcess = .validatePassword
            messages.append(Message(text: "Please enter your password.", sentByUser: false, imageData: nil))
        case .validatePassword :
            messages.append(Message(text: "Logging in", sentByUser: false, imageData: nil))
            loginData.password = textInput
            startLoadingAnimation()
            executeProcess = .login
        }
        textInput = ""
    }
    
    func validateReg() {
        switch regProcess {
        case .validateEmail:
            startLoadingAnimation()
            checkIfEmailExists()
        case .validateCode :
            startLoadingAnimation()
            validateCode()
        case .validatePassword:
            if textInput.count < minPasswordLength || textInput.count >= maxPasswordLength{
                messages.append(Message(text: "Password has to be between 6 and 32 charaters long.", sentByUser: false, isError: true, imageData: nil))
                return
            }
            regData.password = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
            regProcess = .validateConfirmPassword
            placeholder = "confirm password"
            messages.append(Message(text: "Please confirm your password.", sentByUser: false, imageData: nil))
        case .validateConfirmPassword:
            if textInput != regData.password{
                messages.append( Message(text: "Confirm Password doesn't match password.", sentByUser: false, isError: true, imageData: nil))
                return
            }
            regProcess = .validateFirstName
            placeholder = "first name"
            messages.append( Message(text: "What is your first name?", sentByUser: false, imageData: nil))
        case .validateFirstName:
            let isValid = validateNames(text: textInput)
            if isValid.err {
                messages.append( Message(text: isValid.msg, sentByUser: false, isError: true, imageData: nil))
                return
            }
            regData.firstName = textInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            regProcess = .validateLastName
            placeholder = "last name"
            messages.append( Message(text: "What is your last name?", sentByUser: false, imageData: nil))
            
        case .validateLastName:
            let isValid = validateNames(text: textInput)
            if isValid.err{
                messages.append(Message(text: isValid.msg, sentByUser: false, isError: true, imageData: nil))
                return
            }
            regData.lastName = textInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            regProcess = .validateAge
            placeholder = "age"
            messages.append(Message(text: "What is your age?", sentByUser: false, imageData: nil))
        case .validateAge:
            guard let age = Int(textInput) else {
                return messages.append(Message(text: "Please enter a validate age", sentByUser: false, isError: true, imageData: nil))
            }
            if age <= 13{
                return messages.append(Message(text: "Sorry you need to be 13 or older", sentByUser: false, isError: true, imageData: nil))
            }
            print("registering")
            regData.age = age
            startLoadingAnimation()
            executeProcess = .register
        }
        textInput = ""
    }
    
    func checkIfEmailExists() {
        //        return bool if err occurs
        messages.append(Message(text: "Checking your email.", sentByUser: false, isLoadingSign: true, imageData: nil))
        let email = textInput
        Task{ @MainActor in
            print("here", email)
            let res = await AuthServices.checkIfEmailExists(email: email)
            await stopAnimation()
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err, imageData: nil))
            }else{
                regData.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                regProcess = .validateCode
                placeholder = "enter code"
                messages.append(Message(text: res.msg, sentByUser: false, imageData: nil))
            }
        }
    }
    
    func validateCode(){
        // validates the code that was send to users email
        messages.append(Message(text: "Checking code.", sentByUser: false, isLoadingSign: true, imageData: nil))
        let code = textInput
        Task{ @MainActor in
            let res = await AuthServices.vertifyEmail(email: regData.email, code: code)
            await stopAnimation()
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err, imageData: nil))
                return
            }
            messages.append(Message(text: "Email vertified. Enter a password.", sentByUser: false, imageData: nil))
            regProcess = .validatePassword
            placeholder = "password"
        }
    }
    
    func switchTo(){
        // switches between login and registration
        if isOnLogin {
            loginProcess = .validateEmail // this so so that when email is entered for login and than the user switches to register it wont print the email as ***** to messages
            regProcess = .validateEmail
            placeholder = "email"
            messages.append(Message(text: "Signing up instead, Enter your email.", sentByUser: false, imageData: nil))
        } else {
            //            switch to login
            loginProcess = .validateEmail
            regProcess = .validateEmail
            placeholder = "email"
            messages.append( Message(text: "Logging in instead, Enter your email.", sentByUser: false, imageData: nil))
        }
        textInput = ""
        isOnLogin = !isOnLogin
    }
    func goBack(){
        //go back to the previous input field
        if isOnLogin{
            if loginProcess == .validatePassword  {
                loginProcess = .validateEmail
                placeholder = "email"
                messages.append(Message(text: "Enter your email.", sentByUser: false, imageData: nil))
            }else{return} //so it doesnt erase the textInput when still on email
        }else{
            switch regProcess{
            case .validateEmail:
                messages.append(Message(text: "Cant go backward", sentByUser: false, isError: true, imageData: nil))
            case .validateCode:
                regProcess = .validateEmail
                placeholder = "email"
                messages.append(Message(text: "Enter email.", sentByUser: false, imageData: nil))
            case .validatePassword:
                regProcess = .validateEmail
                placeholder = "email"
                messages.append(Message(text: "Enter your email.", sentByUser: false, imageData: nil))
            case .validateConfirmPassword:
                regProcess = .validatePassword
                placeholder = "passsword"
                messages.append( Message(text: "Enter a password.", sentByUser: false, imageData: nil))
            case .validateFirstName:
                placeholder = "password"
                regProcess = .validatePassword
                messages.append( Message(text: "Enter a password.", sentByUser: false, imageData: nil))
            case .validateLastName:
                regProcess = .validateFirstName
                placeholder = "first name"
                messages.append(Message(text: "What is your first name?", sentByUser: false, imageData: nil))
            case .validateAge:
                regProcess = .validateLastName
                placeholder = "last name"
                messages.append(Message(text: "What is your last name?", sentByUser: false, imageData: nil))
            }
        }
        textInput = ""
    }

    func setStartingMsg(){
        let msgs = [
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
        let selectImg = msgs.randomElement()
        messages.append(contentsOf :
                            [
                                Message(text: "Prompt?", sentByUser: false, imageData: nil),
                                Message(
                                    text: selectImg!["prompt"]!,
                                    sentByUser: true, imageData: nil),
                                Message(text: "", sentByUser: false, isImg: true, imageData:
                                            UIImage(named: selectImg!["imageName"]!)?.pngData() )
                            ]
        )
    }
}


