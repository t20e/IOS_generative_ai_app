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
    
    
    private func performAPICall<T: Codable>(
        url: URL?,
        data : Codable,
        token : String?,
        expectedStatusCode : StatusCode,
        method : String,
        expecting: T.Type
    ) async throws -> T? {
        
        guard let url = url else{
            print("Unwrapping Url error")
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(data)
        if token != nil {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let (responseData, headers) = try await URLSession.shared.data(for: request)
        if let httpRes = headers as? HTTPURLResponse {
            let statusCode = StatusCode(rawValue: httpRes.statusCode)
            guard statusCode == expectedStatusCode else{
                throw NetworkError(statusCode!)
            }
            //             If theres any tokens recieved parse it and override any existing tokens in keychains
            let foundCookie = self.parseCookie(httpRes: httpRes)
            if !foundCookie.err{
                print("Found cookie from request")
                // print("cookie here", foundCookie.token, type(of: foundCookie.token))
                guard self.saveToken(token: foundCookie.token) else{
                    throw NetworkError.errorParsingCookie
                }
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(expecting, from: responseData)
            return result
        }
        throw NetworkError.unknown
    }
    
    
    
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
            return(false, "")
            
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
    
    func postCall() throws{
        //        TODO MAKE CODE DRY
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
    
}

