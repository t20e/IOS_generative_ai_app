//
//  ImageServices.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import Foundation

class ImageServices : ObservableObject{
    
    static func downLoadImage(presignedUrl : String) async -> Data? {
        /*
         downloads the image from s3 bucket using the presigned-url, the data will be as data object becuase if i were to make it a UIImage object
         than i woulndt be able to sabe it in a struct which needs to conform to codable, when user is saving it it will need to be a UIImage which we can do by
         converting the data to UIImage and when displaying we convert from data -> UIImage() -> Image()
        */
        do{
            print("Attempting to downloading image from url s3")
            guard let url = URL(string: presignedUrl) else{
                print("Presigned url couln't be converted to URL")
                return nil
            }
            let request = URLRequest(url: url)
            let (data, headers) = try await URLSession.shared.data(for: request)
            if let httpRes = headers as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
                guard statusCode == .success else{
                    throw NetworkError(statusCode!)
                }
                return data
            }
            throw NetworkError.serverErr
        }
        catch let err as NetworkError{
            print("Error occured when downloading image error: \(err)")
            switch err{
                case .forbidden:
                    print("Users presigned url has expired")
                    return nil
                case .timedOut:
                    return nil
                case .serverErr:
                    return nil
                default:
                    return nil
            }
        }
        catch{
            print("An unkown error occured when getting logged user, \(error)")
            return nil
            }
    }    
    
}
