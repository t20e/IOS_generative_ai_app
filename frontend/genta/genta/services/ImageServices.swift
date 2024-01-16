//
//  ImageServices.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import Foundation

class ImageServices : ObservableObject{
    let endPoint = baseURL + "/api/v1/imgs"
    
    static let shared = ImageServices()

    
    struct GenerateImgReturn: Codable {
        var msg : String
        var data : GenerateImgReturnData
    }
    struct GenerateImgReturnData: Codable{
        var imgId : String
        var presignedUrl : String
        var prompt : String
    }
 
    func generateImg(prompt: String, token : String) async -> (err: Bool, msg: String?, data: GenerateImgReturnData?){
        print("Attempting to generate image")
        let url = URL(string: "\(endPoint)/generate")!
//        print(url)
        
        do{
            let res = try await performAPICall(
                url: url,
                data: ["prompt" : prompt],
                token: token,
                expectedStatusCode: .created,
                method: "POST",
                expecting: GenerateImgReturn.self)
            print("Message from server", res?.msg ?? "Could not get message from server parsing error.")
            return (false, res?.msg, res?.data)
        }
                catch let err as NetworkError{
            switch err{
                case .paymentRequired:
                    print("user has generate more than the free amount")
                    return (true, "Sorry you cant generate more free images", nil)
                case .unAuthorized:
                    print("Users token has expired.")
                    return (true, "Your session has expired please sign in again!", nil)
                case .timedOut:
                    print("Your connection timed out, Please check your internet connection!")
                    return (true, "Your connection timed out, Please check your internet connection!", nil )
                case .serverErr:
                    print("Suffered an internal server error, please try later")
                    return (true, "Suffered an internal server error, please try later", nil)
                case .notFound:
                    print("Resource was not found when attempting to generate image")
                    return (true, "Resource was not found, please try later", nil)
                default:
                    print("Uncaught error, please try again")
                    return (true, "Uncaught error, please try again", nil)
                }
            }
        catch {
            print("An unkown error occured when trying to generate an image,\(error)")
                return (true, "An unkown error occured, please try again", nil)
            }
    }
    
    
    func downLoadImage(presignedUrl : String) async -> Data? {
        /*
         downloads the image from s3 bucket using the presigned-url, the data will be as data object
         converting the data to UIImage() to download to users photo album and Image() to display
        */
        do{
            print("Attempting to downloading image from url s3")
            guard let url = URL(string: presignedUrl) else{
                print("Presigned url couldn't be converted to URL")
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
