//
//  ImageServices.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import Foundation

class ImageServices : ObservableObject{
    
    func downLoadImage(presignedUrl : String) async -> (err: Bool, imgData: String?){
        /*
         downloads the image from s3 bucket using the presigned-url the data will
         be base64 so i can store it in a struct that Codable and then will use the
         base64 to generate the UIImage when needed for user to save and use the base64 to display the image on views
        */
        guard let url = URL(string: presignedUrl) else{
            print("Presigned url couln't be converted to URL")
            return (true, nil)
        }
        var request = URLRequest(url: url)
        do{
            let (data, headers) = try await URLSession.shared.data(for: request)
            return (false, "")
            print("recieved data",data)
        }catch{
            print("An unkown error occured when getting logged user, \(error)")
                return (true, nil)
            }
    }
}
