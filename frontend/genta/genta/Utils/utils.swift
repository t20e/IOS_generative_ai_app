//
//  utils.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


enum StatusCode : Int{
    case success = 200, created = 201, accepted = 202, notFound = 404,  unAuthorized = 401, timedOut = 408, conflict = 409, semanticError = 422, serverErr = 500
}

enum NetworkError: Error {
    case success
    case created
    case accepted
    case notFound
    case serverErr
    case unAuthorized
    case timedOut
    case conflict
    case semanticError

    init(_ statusCode: StatusCode) {
        switch statusCode {
            case .success: self = .success
            case .created: self = .created
            case .accepted: self = .accepted
            case .notFound: self = .notFound
            case .serverErr: self = .serverErr
            case .unAuthorized: self = .unAuthorized
            case .timedOut: self = .timedOut
            case .conflict: self = .conflict
            case .semanticError: self = .semanticError
        }
    }
}

//TODO remove all this and fix it in userServices
func handleStatusCode( statusCode: StatusCode) -> String  {
    print("Handle status code errors, code: \(statusCode)")
    var msg = ""
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
    return msg
}
