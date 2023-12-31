//
//  ImageServices.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import Foundation

class ImageServices : ObservableObject{
    let endPoint = baseURL + "/api/v1/imgs"
    
    
    struct GenerateImgReturn: Codable {
        var msg : String
        var data : GenerateImgReturnData
    }
    struct GenerateImgReturnData: Codable{
        var imgId : String
        var presignedUrl : String
        var prompt : String
    }

    
    
    func generateImgApiCAll(prompt: String, token : String) async -> (err: Bool, msg: String, data: GenerateImgReturnData?){
        print("Attempting to generate image")
        let url = URL(string: "\(endPoint)/generate")!
//        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            token,
            forHTTPHeaderField: "Authorization"
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let encodedData = try JSONEncoder().encode(["prompt" : prompt])
            let (data, headers) = try await URLSession.shared.upload(for: request, from: encodedData)

            if let httpRes = headers as? HTTPURLResponse {
                let statusCode = StatusCode(rawValue: httpRes.statusCode)
                guard statusCode == .created else{
                    print("return error status code : \(String(describing: statusCode))")
                    throw NetworkError(statusCode!)
                }
//                For testing turn the byte data into a hex then turn it back into a data in a playground
//                print( String(bytes: data, encoding: .utf8) ?? "Error printing byte to string")
//                let hexString = data.map { String(format: "%02hhx", $0) }.joined()
//                print("here",hexString)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedByte = try decoder.decode(GenerateImgReturn.self, from: data)
                print(decodedByte.data)
                print("Message from server",decodedByte.msg)
                
                return (false, decodedByte.msg, decodedByte.data)
            }else{
                throw NetworkError.serverErr
            }
        }catch let err as NetworkError{
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
         downloads the image from s3 bucket using the presigned-url, the data will be as data object becuase if i were to make it a UIImage object
         than i woulndt be able to sabe it in a struct which needs to conform to codable, when user is saving it it will need to be a UIImage which we can do by
         converting the data to UIImage and when displaying we convert from data -> UIImage() -> Image()
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
