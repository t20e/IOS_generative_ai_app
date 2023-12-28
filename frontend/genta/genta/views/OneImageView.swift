//
//  OneImageView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct OneImageView: View {
    var prompt : String
    var uiImage : UIImage
    
    var body: some View {
        VStack{
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: UIScreen.main.bounds.width
//                    height: UIScreen.main.bounds.height / 2
                )
            
            Text("Prompt: \(prompt)")
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            Button(action: {
//                ImageSaver.writeToPhotoAlbum(image: uiImage)
                saveImage()
            }, label: {
                Image(systemName: "square.and.arrow.down")
                    .resizable()
                    .frame(
                        width: 20,
                        height: 25
                    )
            })
            .foregroundColor(.red)
        }
    }  
    func saveImage(){
        let imageSaver = ImageSaver()
        imageSaver.successHandler={
            print("Successfully saved image to users photo album")
        }
        imageSaver.errorHandler = {
            print("Error saving image to users photo album, Error: \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: uiImage)
    }
}

#Preview {
    OneImageView(
        prompt: "a lion walking through the artic wildlands, with a pariot side-kick",
         uiImage: UIImage( imageLiteralResourceName: "test_img"))
}
