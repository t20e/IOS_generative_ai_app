////
////  LoginController.swift
////  genta
////
////  Created by Tony Avis on 12/18/23.
////
//
//import Foundation
//import SwiftUI
//import SwiftData
//
//struct LoginData : Codable{
//    var email: String
//    var password: String
//}
//
//struct RegData : Codable{
//    var email : String
//    var password: String
//    var firstName: String
//    var lastName : String
//    var age: Int
//}
//
//enum LoginValidateEnum {
//    case validateEmail, validatePassword
//}
//
//enum RegisterValidateEnum{
//    case validateEmail, validateCode, validatePassword, validateConfirmPassword,  validateFirstName, validateLastName, validateAge
//}
//
//
//@MainActor
//class LoginRegController : ObservableObject{
//    
////    var modelContext: ModelContext
////    var user = User()
//    
//    @Environment(\.modelContext) var context
//        
//    let minPasswordLength = 6
//    let maxPasswordLength = 32
//    
//    @Published var loginProcess = LoginValidateEnum.validateEmail
//    @Published var regProcess = RegisterValidateEnum.validateEmail
//    @Published var placeholder = "email"
//
//    @Published var loginData = LoginData(email: "", password: "")
//    @Published var regData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0)
//    
//    
//    var exampleGeneratedImages : [[String : String]]
//
//    
//    init( user: User = User(), loginProcess: LoginValidateEnum = LoginValidateEnum.validateEmail, regProcess: RegisterValidateEnum = RegisterValidateEnum.validateEmail, placeholder: String = "email", loginData: LoginData = LoginData(email: "", password: ""), regData: RegData = RegData(email: "", password: "", firstName: "", lastName: "", age: 0), exampleGeneratedImages: [[String : String]] = [
//        [
//            "prompt": "Design a captivating image of a city in the future, featuring towering skyscrapers made of gleaming glass and steel structures. The city should have flying cars and monorail systems zipping through the sky. There should be rooftop gardens on some buildings, demonstrating city dwellers' commitment to urban green spaces.",
//            "imageName": "Design_a_captivating_image_of_a_city_in_the_future,"
//        ],
//        [
//            "prompt": "Create an image comprising abstract geometric patterns. These patterns should take various forms such as squares, triangles, circles, and polygons, among others.",
//            "imageName": "abstractGeometricPattern"
//        ],
//        [
//            "prompt": "Imagine a scene in a cloudy sky, filled with intricately designed flying machines inspired by the steampunk aesthetic.",
//            "imageName": "steamPunk"
//        ],
//        [
//            "prompt": "Imagine a whimsical scene set in a well-maintained garden full of flowers and lush greenery. In this garden, there is an unusual, joyful gathering taking place. A troupe of quirky robots, all of different shapes, sizes and colors, are happily engaged in a tea party.",
//            "imageName": "robotsDiner"
//        ]
//    ]) {
////        self.user = user
//        self.loginProcess = loginProcess
//        self.regProcess = regProcess
//        self.placeholder = placeholder
//        self.loginData = loginData
//        self.regData = regData
//        self.exampleGeneratedImages = exampleGeneratedImages
//    }
//    
//    func test(){
//        context.insert(User())
//    }

//    
//}
