//
//  utils.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


enum StatusCode : Int{
    case success = 200, created = 201, accepted = 202, notFound = 404,  unAuthorized = 401, timedOut = 408, conflict = 409, semanticError = 422, serverErr = 500
}

enum NetworkError: Error {
    case success
    case created
    case accepted
    case notFound
    case serverErr
    case unAuthorized
    case timedOut
    case conflict
    case semanticError

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
        }
    }
}
