//
//  utils.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

enum StatusCode : Int{
    case success = 200, notFound = 404, serverErr = 500, unAuthorized = 401, timedOut = 408
}

func handleStatusCode( statusCode: StatusCode) -> (err : Bool, msg : String)  {
    print("Handle login errors...")
    var msg = ""
    var err = true
    switch statusCode {
        case .unAuthorized:
            print("Unauthorized. User authentication is required.")
            msg = "Wrong email/password please try again!"
//            return ["err" : true, "msg" : "Wrong email/password please try again!"]
        case .notFound:
            print("Please retry again, not found")
            msg = "Please try later, resource not found!"
//            return ["err" : true, "msg" : "Please try later, resource not found!"]
        case .serverErr:
            print("Suffered an internal server error")
            msg = "Please try later, suffered internal error!"
//            return ["err" : true, "msg" : "Please try later, suffered internal error!"]
        case .timedOut:
            print("server timed out")
            msg = "Your connection timed out, Please check your internet connection!"
//            return ["err" : true, "msg" : "Your connection timed out, Please check your internet connection!"]
        default:
            msg = "An unkown error occured, please try again!"
//            return ["err" : true, "msg" : "An unkown error occured, please try again!"]
    }
    return (err, msg)
}
