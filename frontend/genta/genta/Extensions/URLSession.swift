//
//  URLSession.swift
//  genta
//
//  Created by Tony Avis on 12/31/23.
//

import Foundation


extension URLSession{
//    func request< T: Codable>(
//        url: URL?,
//        data : Codable,
//        expectedStatusCode : StatusCode,
//        method : String,
//        expecting: T.Type,
//        completion: @escaping (Result<T, Error>) 
////        -> (err: Bool, msg:String, data : T?)
//        -> Void
//    ){
//        /*
//         Parameters:
//            T: represents an obj that is codabale could be any so long as it extends the codable protocol
//            expectedStatusCode:  is the expected Successful status code so if the expected is .created code and a .success code was return this will be an error look in StatusCode struct for more info
//         */
//        //        unwrap the url
//        guard let url = url else{
//            print("Unwrapping Url error")
//            completion(.failure(NetworkError.invalidUrl))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        do{
//            request.httpBody = try JSONEncoder().encode(data)
//        }catch{
//            print("Error converting data into json")
//            completion(.failure(NetworkError.invalidData))
//            return
//        }
//        
//        let task = dataTask(with: request){ data, headers, error in
//            if let httpRes = headers as? HTTPURLResponse {
//                let statusCode = StatusCode(rawValue: httpRes.statusCode)
//                print("Return status code: \(String(describing: statusCode))")
//                guard statusCode == .success else{
//                    completion(.failure(NetworkError(statusCode!)))
//                    return
//                }
//                
//                //  If theres any tokens recieved parse it and override any existing tokens in keychains
//                let foundCookie = self.parseCookie(httpRes: httpRes)
//                if !foundCookie.err{
//                    print("Found cookie from request")
//                    // print("cookie here", foundCookie.token, type(of: foundCookie.token))
//                    // save token
//                    guard self.saveToken(token: foundCookie.token) else{
//                        completion(.failure(NetworkError.errorParsingCookie))
//                        return
//                    }
//                }
//
//                guard let data = data else{
//                    if let error = error{
//                        completion(.failure(error))
//                    }else{
//                        completion(.failure(NetworkError.invalidData))
//                    }
//                    return
//                }
//                
//                do{
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let result = try decoder.decode(expecting, from: data)
//                    completion(.success(result))
//                }catch{
//                    completion(.failure(error))
//                }
//            }
//        }
//        task.resume()
//    }
    

    
}
