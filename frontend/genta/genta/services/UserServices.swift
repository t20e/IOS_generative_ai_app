//
//  UserServices.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


struct resReturnUserData: Codable {
    let data: UserStruct
    let msg: String
}


class UserServices : ObservableObject{
    private let endPoint = baseURL + "/api/v1/users"
    
    init(){
    }
    
    func regApiCall(regData: RegData) async  -> (err: Bool, msg: String, user: UserStruct?){
        print("Attempting to register user")
        
        let url = URL(string: "\(self.endPoint)/reg")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let encodedData = try JSONEncoder().encode(regData)
            let (data, res) = try await URLSession.shared.upload(for: request, from: encodedData)
            print( String(data: data, encoding: .utf8) ?? "error parsing response data")
            if let httpRes = res as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
                guard statusCode == .created else{
                    throw NetworkError(statusCode!)
                }
    
                //                parse cookie
                let foundCookie = parseCookie(httpRes: httpRes)
                if foundCookie.err{
                    throw NetworkError.serverErr
                }
                //                print("cookie here", foundCookie.token, type(of: foundCookie.token))
                //                save token
                guard saveToken(token: foundCookie.token) else{
                    throw NetworkError.serverErr
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedByte = try decoder.decode(resReturnUserData.self, from: data)
                let user = decodedByte.data
//                print(user)
                return (false, "Successfully signed in", user)
            }else{
                print("Error parsing JSON data at checking if email exists")
                throw NetworkError.serverErr
            }
        }
        catch let err as NetworkError{
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
    
    func postCall(){
        //        TODO MAKE CODE DRY
    }
    
    private func parseCookie(httpRes : HTTPURLResponse) -> (err: Bool, token : String){
//        parse cookie from response data
        if let setCookieHeader = httpRes.allHeaderFields["Set-Cookie"] as? String {
               // Parse cookies using HTTPCookie
               let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": setCookieHeader], for: httpRes.url!)
               // Access individual cookies
               if let userTokenCookie = cookies.first(where: { $0.name == "userToken" }) {
                   print("Found UserToken value in response header")
                   return (false, userTokenCookie.value)
               } else {
                   print("User Token Cookie not found")
                   return (true, "")
               }
           } else {
               print("Set-Cookie Header not found in the response")
               return (true, "")
           }
    }
    
    private func saveToken(token : String) -> Bool{
//        saves token to keychain
        return KeyChainManager.upsert(token: token)
    }
    
    //    MARK - login
    func loginApiCall(loginData: LoginData) async -> (err : Bool, msg : String, user: UserStruct?) {
        print("Attempting to login in user")
        let url = URL(string: "\(endPoint)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let encodedData = try JSONEncoder().encode(loginData)
            let (data, res) = try await URLSession.shared.upload(for: request, from: encodedData)
            
            if let httpRes = res as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
//                print(res)
//                print("Token",httpRes.allHeaderFields)
                guard statusCode == .success else{
                    throw NetworkError(statusCode!)
                }
                //                parse cookie
                let foundCookie = parseCookie(httpRes: httpRes)
                if foundCookie.err{
                    throw NetworkError.serverErr
                }
                //                print("cookie here", foundCookie.token, type(of: foundCookie.token))
                
                //                save token
                guard saveToken(token: foundCookie.token) else{
                    throw NetworkError.serverErr
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedByte = try decoder.decode(resReturnUserData.self, from: data)
                let user = decodedByte.data
//                print(user)
                return (false, "Successfully signed in", user)
            }else{
                print("Error parsing JSON data at checking if email exists")
                throw NetworkError.serverErr
            }
        }
        catch let err as NetworkError{
            switch err{
            case .unAuthorized:
                print("Unauthorized. User entered wrong field login.")
                return (true, "Wrong email/password please try again!", nil)
            case .timedOut:
                return (true, "Your connection timed out, Please check your internet connection!", nil )
            case .serverErr:
                return (true, "Suffered an internal server error, please try later", nil)
            default:
                return (true, "Uncaught error, please try again", nil)
            }
        }
        catch {
            return (true, "An unkown error occured, please try again", nil)
        }
    }
    
    func checkIfEmailInDbApiCall(email : String) async -> (err : Bool, msg : String){
        print("Checking if email is already in use")
        let url = URL(string: "\(endPoint)/checkIfEmailExists")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let encodedData = try JSONEncoder().encode(["email" : email])
            let (data, res) = try await URLSession.shared.upload(for: request, from: encodedData)
            
            if let httpRes = res as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
                guard statusCode == .accepted else{
                    throw NetworkError(statusCode!)
                }
            }
            print( String(data: data, encoding: .utf8) ?? "error parsing response data")
            if let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                print("dict", dict)
                return (false, "")
            }
            else{
                print("Error parsing JSON data at checking if email exists")
                throw NetworkError.serverErr
            }
        }
        
        catch let err as NetworkError{
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
    
    
    func logInUserFromToken(token : String) async -> (err : Bool, msg : String, user: UserStruct?) {
        print("Attempting to log in user from token")
        let url = URL(string: "\(endPoint)/getLoggedUser")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            token,
            forHTTPHeaderField: "Authorization"
        )
        do{
            let (data, headers) = try await URLSession.shared.data(for: request)
            if let httpRes = headers as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
                  guard statusCode == .success else{
                    print("return status code : \(String(describing: statusCode))")
                    throw NetworkError(statusCode!)
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
//                print( String(bytes: data, encoding: .utf8) ?? "Error printing byte to string")
                
                let decodedByte = try decoder.decode(resReturnUserData.self, from: data)
                let user = decodedByte.data
//                print(user)
                return (false, "Successfully signed in", user)
            }else{
                throw NetworkError.serverErr
            }
        }
        catch let err as NetworkError{
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
    
}
