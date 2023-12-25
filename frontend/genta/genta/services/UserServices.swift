//
//  UserServices.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


class UserServices : ObservableObject{
    let endPoint = "http://localhost:8080/api/v1/users"

    
    init(){    }
    
    
    func regApiCall(regData: RegData) async  -> (err: Bool, msg: String, user: UserStruct?){
        print("Attempting to register user")
        
        let url = URL(string: "\(endPoint)/reg")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let encodedData = try JSONEncoder().encode(regData)
            let (data, res) = try await URLSession.shared.upload(for: request, from: encodedData)
            
            if let httpRes = res as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
                if statusCode != .created{
                    return (true, handleStatusCode(statusCode: statusCode!), nil)
                }
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let user = try decoder.decode(UserStruct.self, from: data)
            print(user)
            return (false, "Successfully registered", user)
        }
        catch {
            return (true, "An unkown error occured, please try again", nil)
        }
    }
    
    func postCall(){
//        TODO MAKE CODE DRY
    }

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
                if statusCode != .success{
                    return (true, handleStatusCode(statusCode: statusCode!), nil)
                }
            }
        //            print( String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let user = try decoder.decode(UserStruct.self, from: data)
            print(user)
            return (false, "Successfully signed in", user)
    //        return ["err" : false, "msg" : "Successfully signed in"]
        }
        //        catch(CustomError.unAuthorized){
        //            return ["err" : true, "msg" : "Incorrect email or password please try again"]
        //        }
        //        catch(CustomError.notFound){
        //            return ["err" : true, "msg" : "Please try later resource is not found"]
        //        }
        //        catch(CustomError.serverErr){
        //            return ["err" : true, "msg" : "Please try later, suffered internal error"]
        //        }
        //        catch(CustomError.timedOut){
        //            return ["err" : true, "msg" : "Your connection timed out, please try later"]
        //        }
        catch {
            return (true, "An unkown error occured, please try again", nil)
    //        return ["err" : true, "msg" : "An unkown error occured, please try again"]
        }
    }
    
}
