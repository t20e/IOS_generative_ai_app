//
//  NetworkUtils.swift
//  genta
//
//  Created by Tony Avis on 12/31/23.
//

import Foundation

enum StatusCode : Int{
    case success = 200, created = 201, accepted = 202, unAuthorized = 401, forbidden = 403, notFound = 404, timedOut = 408, conflict = 409, semanticError = 422, serverErr = 500
}

enum NetworkError: Error {
    case success, created, accepted, notFound, serverErr, unAuthorized, timedOut, conflict, semanticError, forbidden, invalidUrl, invalidData, errorParsingCookie, unknown

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
            case .forbidden: self = .forbidden
        }
    }
    
    
}


