//
//  UserServices.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


struct generated_imgs: Codable{
    var imgId : String
    var prompt : String
}

struct User: Codable{
//    since the convesion for swiftui is camelcase we can convert any snakecases that theapi sends back
    let email : String
    let firstName : String
    let lastName : String
    let age : Int
    let generatedImgs : [generated_imgs]
}
   


class UserServices{
    let endPoint = "http://localhost:8080/api/v1/users"
    init(){    }

        
    func loginApiCall(loginData: LoginData) async throws -> (err : Bool, msg : String) {
    let url = URL(string: "\(endPoint)/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let encodedData = try JSONEncoder().encode(loginData)

    do{
        let (data, res) = try await URLSession.shared.upload(for: request, from: encodedData)

        if let httpRes = res as? HTTPURLResponse {
            let statusCode = StatusCode(rawValue: httpRes.statusCode)
            if statusCode != .success{
                return handleStatusCode(statusCode: statusCode!)
            }
        }
    //            print( String(data: data, encoding: .utf8))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(User.self, from: data)
        print(user)
        let err = false
        let msg = "Successfully signed in"
        return (err, msg)
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
        let err = true
        let msg = "An unkown error occured, please try again"
        return (err, msg)
//        return ["err" : true, "msg" : "An unkown error occured, please try again"]
    }
    }
    
}
