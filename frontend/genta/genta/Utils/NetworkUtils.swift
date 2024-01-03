//
//  NetworkUtils.swift
//  genta
//
//  Created by Tony Avis on 12/31/23.
//

import Foundation

enum StatusCode : Int{
    case success = 200, created = 201, accepted = 202, badRequest = 400, unAuthorized = 401, paymentRequired = 402, forbidden = 403, notFound = 404, timedOut = 408, conflict = 409, semanticError = 422, serverErr = 500
}

enum NetworkError: Error {
    case success, created, accepted, notFound, serverErr, unAuthorized, timedOut, conflict, semanticError, forbidden, invalidUrl, invalidData, errorParsingCookie, unknown, badRequest, paymentRequired

    init(_ statusCode: StatusCode) {
        switch statusCode {
            case .success: self = .success
            case .created: self = .created
            case .accepted: self = .accepted
            case .notFound: self = .notFound
            case .serverErr: self = .serverErr
            case .badRequest : self = .badRequest
            case .unAuthorized: self = .unAuthorized
            case .timedOut: self = .timedOut
            case .conflict: self = .conflict
            case .semanticError: self = .semanticError
            case .forbidden: self = .forbidden
            case .paymentRequired: self = .paymentRequired
        }
    }
    
    
}


func performAPICall<T: Codable>(
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
        let foundCookie = parseCookie(httpRes: httpRes)
        if !foundCookie.err{
            print("Found cookie from request")
            // print("cookie here", foundCookie.token, type(of: foundCookie.token))
            guard  saveToken(token: foundCookie.token) else{
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


func parseCookie(httpRes : HTTPURLResponse) -> (err: Bool, token : String){
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


func saveToken(token : String) -> Bool{
    //        saves token to keychain
    return KeyChainManager.upsert(token: token)
}

