//
//  UserServices.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


struct resReturnUserData: Codable {
    let data: UserData
    let msg: String
}

struct resSimpleData : Codable{
//    returns of simple msg and a data dictionary
    let msg : String
    let data : [String : Bool]
}

class UserServices : ObservableObject{
    private let endPoint = baseURL + "/api/v1/users"
    
    
    
    
    
    func regApiCall(regData: RegData) async  -> (err: Bool, msg: String, user: UserData?){
        print("Attempting to register user")
        
        let url = URL(string: "\(self.endPoint)/reg")!
        
        do{
            let res = try await performAPICall(url: url, data: regData, token: nil, expectedStatusCode: .created, method: "POST", expecting: resReturnUserData.self)
            let user = res?.data
            return (false, "Successfully registered", user)
        } catch let err as NetworkError{
            switch err{
            case .conflict:
                return(true, "Email already in use, please sign in", nil)
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!", nil )
            case .serverErr:
                return (true, "Suffered an internal server error, please try later", nil)
            default:
                return (true, "Uncaught error, please try again", nil)
            }
        }
        catch {
            print("An unkown error occured when registering")
            return (true, "An unkown error occured, please try again", nil)
        }
    }
    
    
    
    //    MARK - login
    func loginApiCall(loginData: LoginData) async -> (err : Bool, msg : String, user: UserData?) {
        print("Attempting to login in user")
        
        let url = URL(string: "\(endPoint)/login")!
        do{
            let res = try await performAPICall(
                url: url,
                data: loginData,
                token: nil,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resReturnUserData.self)
            let user = res?.data
            return (false, "Successfully signed in", user)
        }catch let err as NetworkError{
            switch err{
            case .unAuthorized:
                print("Unauthorized. User entered wrong field login.")
                return (true, "Wrong email/password please try again!", nil)
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!", nil )
            case .serverErr:
                return (true, "Suffered an internal server error, please try later", nil)
            case .unknown:
                return (true, "An unkown error occured, please try again", nil)
            default:
                return (true, "Uncaught error, please try again", nil)
            }
        }catch{
            return (true, "An unkown error occured, please try again", nil)
        }
    }
    
    
    func checkIfEmailInDbApiCall(email : String) async -> (err : Bool, msg : String){
        print("Checking if email is already in use")
        let url = URL(string: "\(endPoint)/checkIfEmailExists")!
        
        do{
            let res = try await performAPICall(
                url: url,
                data: ["email" : email],
                token: nil,
                expectedStatusCode: .accepted,
                method: "POST",
                expecting: resSimpleData.self)
            print("response data", res?.msg ?? "Error parsing return data")
            return(false, "A code has been sent to your email, please enter it. It might be in spam.")
            
        } catch let err as NetworkError{
            switch err{
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            case .conflict:
                return (true, "Email already in use, sign in!")
            case .semanticError:
                return (true, "Please enter a valid email address")
            default:
                return (true, "Uncaught error, please try again")
            }
        }
        catch {
            return (true, "An unkown error occured, please try again later")
        }
    }
    
    
    func logInUserFromToken(token : String) async -> (err : Bool, msg : String, user: UserData?) {
        print("Attempting to log in user from token")
        let url = URL(string: "\(endPoint)/getLoggedUser")!
        do{
            let res = try await performAPICall(
                url: url,
                data: ["None": "None"],
                token: token,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resReturnUserData.self)
//            print("res data from loggin in user", res)
            let user = res?.data
            return (false, "Successfully logged in", user)
        } catch let err as NetworkError{
            switch err{
            case .unAuthorized:
                print("Users token has expired.")
                return (true, "Your session has expired please sign in again!", nil)
            case .timedOut:
                print("Your connection timed out, Please check your internet connection!")
                return (true, "Your connection timed out, Please check your internet connection!", nil )
            case .serverErr:
                print("Suffered an internal server error, please try later")
                return (true, "Suffered an internal server error, please try later", nil)
            default:
                print("Uncaught error, please try again")
                return (true, "Uncaught error, please try again", nil)
            }
        }
        catch {
            print("An unkown error occured when getting logged user ,\(error)")
            return (true, "An unkown error occured, please try again", nil)
        }

    }
    
    func setUpRequest(url: String, token: String) -> URLRequest{
        let urlObj = URL(string: url)
        var request = URLRequest(url: urlObj!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            token,
            forHTTPHeaderField: "Authorization"
        )
        return request
    }
    
    
    func getSupport(token : String, issue : String) async -> (err:Bool, msg : String){
        print("Attempting to get support")
        let url = URL(string: "\(endPoint)/contactUs")
        do{
            let res = try await performAPICall(url: url, data: ["issue" : issue], token: token, expectedStatusCode: .success, method: "POST", expecting: resSimpleData.self)
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
    
    func vertifyEmail(email:String, code:String) async -> (err: Bool, msg:String){
        let url = URL(string: "\(endPoint)/verifyCode")
        do{
            _ = try await performAPICall(
                url: url,
                data: ["email": email, "code": code],
                token: nil,
                expectedStatusCode:.success,
                method: "POST",
                expecting: resSimpleData.self)
            return (false, "")
        }catch let err as NetworkError{
            switch err {
            case .badRequest:
                return (true, "The code you entered was incorrect, try again.")
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            default:
                return (true, "Uncaught error, please try again")
            }
        } catch {
            return (true, "An unkown error occured, please try again later")
        }
    }
    
    func getCode(email : String, token:String)async -> (err:Bool, msg:String){
        let url = URL(string: "\(endPoint)/getCodeToEmail")
        do{
            _ = try await performAPICall(
                url: url,
                data: ["email" : email],
                token: token,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resSimpleData.self)
            return (false, "We sent a code to your email, please enter it. Be sure to check spam.")
        } catch let err as NetworkError{
            switch err {
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            default:
                return (true, "Uncaught error, please try again")
            }
        } catch {
            return (true, "An unkown error occured, please try again later")
        }
    }
    
    func changePassword(email: String, code: String, newPassword : String, token: String) async -> (err: Bool, msg:String){
        let url = URL(string: "\(endPoint)/changePassword")
        do{
            _ = try await performAPICall(
                url: url,
                data: [
                    "email" : email,
                    "code" : code,
                    "newPassword" : newPassword
                ],
                token: token,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resSimpleData.self)
            return (false, "Your password was updated.")
        } catch let err as NetworkError{
            switch err {
            case .badRequest:
                return (true, "The code you entered was incorrect, please try again.")
            case .unAuthorized:
                return(true, "Your credentials are wrong please log back in.")
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            default:
                return (true, "Uncaught error, please try again")
            }
        } catch {
            return (true, "An unkown error occured, please try again later")
        }
    }
    
    
    func deleteAccount(email:String, password : String, token:String) async -> (err:Bool, msg:String){
        let url = URL(string: "\(endPoint)/deleteAccount")
        do{
            _ = try await performAPICall(
                url: url,
                data: ["email":email, "password" : password],
                token: token,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resSimpleData.self)
            return (false, "Account has been deleted")
        }catch let err as NetworkError{
            switch err {
            case .unAuthorized:
                return(true, "Your credentials are wrong wrong.")
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            default:
                return (true, "Uncaught error, please try again")
            }
        } catch {
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


