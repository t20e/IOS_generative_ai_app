//
//  UserServices.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation
 

class UserServices : ObservableObject{
    let endPoint = baseURL + "/api/v1/users"
    static let shared = UserServices()


    func getSupport(user : CDUser, token : String, issue : String) async -> (err:Bool, msg : String){
        print("Attempting to get support")
        let url = URL(string: "\(endPoint)/contactUs")
        do{
            let res = try await performAPICall(
                url: url,
                data: [
                    "email" : user.email,
                    "firstName" : user.firstName,
                    "userId" : user.id,
                    "issue" : issue
                ],
                token: token,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resSimpleData.self
            )
            print("return msg",res?.msg ?? "Error getting the msg from res body")
            return (false, "Issue received")
        } catch let err as NetworkError{
            switch err{
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            case .unAuthorized:
                return(true, "Please log back in")
            default:
                return (true, "Uncaught error, please try again")
            }
        }
        catch {
            return (true, "An unkown error occured, please try again later")
        }
    }
    
}

//func basicHandleCatchError(_ error: NetworkError) -> (Bool, String) {
//    switch error {
//    case .badRequest:
//        return (true, "The code you entered was incorrect, please try again.")
//    case .unAuthorized:
//        return (true, "Your credentials are wrong, please log back in.")
//    case .serverErr:
//        return (true, "Suffered an internal server error, please try later")
//    case .timedOut:
//        return (true, "Your connection timed out, please check your internet connection!")
//    default:
//        return (true, "Uncaught error, please try again")
//    }
//}


