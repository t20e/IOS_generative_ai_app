//
//  AuthServices.swift
//  genta
//
//  Created by Tony Avis on 1/7/24.
//

import Foundation

struct resReturnUserData: Codable {
    let data: User
    let msg: String
}

struct resSimpleData : Codable{
    //    returns of simple msg and a data dictionary
    let msg : String
    let data : [String : Bool]
}


final class AuthServices{
    let endPoint = baseURL + "/api/v1/users"
    
    static let shared = AuthServices()

    
    func register(regData: RegData) async  -> (err: Bool, msg: String, user : User?){
        print("Attempting to register user")
        
        let url = URL(string: "\(self.endPoint)/reg")!
        
        do{
            let res = try await performAPICall(
                url: url,
                data: regData,
                token: nil,
                expectedStatusCode: .created,
                method: "POST",
                expecting: resReturnUserData.self
            )
            let user = res?.data
            print("heer", user!)
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
            print("An unkown error occured when registering, error: \(error)")
            return (true, "An unkown error occured, please try again", nil)
        }
    }
    //    MARK - login
    func login(loginData: LoginData) async -> (err : Bool, msg : String, user: User?) {
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
//            print("login return data:",type(of: user))
            return (false, "Successfully signed in", user)
        }catch let err as NetworkError{
            switch err{
            case .unAuthorized:
                print("Unauthorized. User entered wrong field login.")
                return (true, "Wrong credentials, please try again!", nil)
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" , nil)
            case .serverErr:
                return (true, "Suffered an internal server error, please try later", nil)
            case .unknown:
                return (true, "An unkown error occured, please try again", nil)
            default:
                return (true, "Uncaught error, please try again", nil)
            }
        }catch{
            print("An unkown error occured when loggin in, error: \(error)")
            return (true, "An unkown error occured, please try again", nil)
        }
    }
    
    func checkIfEmailExists(email : String) async -> (err : Bool, msg : String){
        /*
         when user attempts to register we need to make sure that the email isnt in db
         */
        print("Checking if email is already in use, data: \( ["email" : email])")
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
            print("An unkown error occured when checking if email exists, error: \(error)")
            return (true, "An unkown error occured, please try again later")
        }
    }
    
    
    func vertifyEmail(email:String, code:String) async -> (err: Bool, msg:String){
        /*
         when user attempts to register they will get a code sent to their email which will need to be vertified here
         */
        print("Vertifying code: \(code), email: \(email)")
        let url = URL(string: "\(endPoint)/verifyEmail")
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
            case .unAuthorized:
                return (true, "The code you entered was incorrect, try again.")
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            default:
                return (true, "Uncaught error, please try again")
            }
        } catch {
            print("An unkown error occured when vertifying email, error: \(error)")
            return (true, "An unkown error occured, please try again later")
        }
    }
    
    func getCode(email : String, firstName: String, accessToken : String) async -> (err:Bool, msg:String){
        let url = URL(string: "\(endPoint)/getCodeToEmail")
        do{
            _ = try await performAPICall(
                url: url,
                data: [
                    "email" : email,
                    "firstName" : firstName
                ],
                token: accessToken,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resSimpleData.self
            )
            return (false, "We sent a code to your email, please enter it. Be sure to check spam.")
        } catch let err as NetworkError{
            switch err {
            case .serverErr:
                return (true, "Suffered an internal server error, please try later")
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!" )
            case .unAuthorized:
                return (true, "Something went wrong, check your email." )
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
                data: [
                    "email":email,
                    "password" : password
                ],
                token: token,
                expectedStatusCode: .success,
                method: "POST",
                expecting: resSimpleData.self
            )
            return (false, "Account has been deleted")
        }catch let err as NetworkError{
            switch err {
            case .unAuthorized:
                return(true, "Your credentials are wrong wrong.")
            case .serverErr:
                return (true, "Issue deleting account, please try later or contact us!")
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



//
//    func logInUserFromToken(token : String) async -> (err : Bool, msg : String, user: UserData?) {
//        print("Attempting to log in user from token")
//        let url = URL(string: "\(endPoint)/getLoggedUser")!
//        do{
//            let res = try await performAPICall(
//                url: url,
//                data: ["None": "None"],
//                token: token,
//                expectedStatusCode: .success,
//                method: "POST",
//                expecting: resReturnUserData.self)
////            print("res data from loggin in user", res)
//            let user = res?.data
//            return (false, "Successfully logged in", user)
//        } catch let err as NetworkError{
//            switch err{
//            case .unAuthorized:
//                print("Users token has expired.")
//                return (true, "Your session has expired please sign in again!", nil)
//            case .timedOut:
//                print("Your connection timed out, Please check your internet connection!")
//                return (true, "Your connection timed out, Please check your internet connection!", nil )
//            case .serverErr:
//                print("Suffered an internal server error, please try later")
//                return (true, "Suffered an internal server error, please try later", nil)
//            default:
//                print("Uncaught error, please try again")
//                return (true, "Uncaught error, please try again", nil)
//            }
//        }
//        catch {
//            print("An unkown error occured when getting logged user ,\(error)")
//            return (true, "An unkown error occured, please try again", nil)
//        }
//
//    }
//
