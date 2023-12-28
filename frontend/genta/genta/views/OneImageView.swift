//
//  OneImageView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct OneImageView: View {
    @State var prompt : String
    @State var uiImage : UIImage
    @Binding var showPopUp : Bool
    
    var body: some View {
        
        if showPopUp{
            VStack{
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: UIScreen.main.bounds.width
    //                    height: UIScreen.main.bounds.height / 2
                    )
                    .cornerRadius(5)
                    .padding(10)
                if prompt.hasPrefix("REVISED###"){
                    Text("Revised Prompt: \(String(prompt.dropFirst(10)))")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                }else{
                    Text("Prompt: \(prompt)")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                }
    
                Button(action: {
                    saveImage()
                }, label: {
//                    Image(systemName: "arrowshape.down.circle")
//                    Image(systemName: "arrow.down.to.line.circle.fill")
                    Image(systemName: "icloud.and.arrow.up.fill")
                    
                        .resizable()
                        .frame(
                            width: 35,
                            height: 35
                        )
                        .padding(.top, 15)
                })
                .foregroundColor(.red)
            }
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
        prompt: "REVISED###A lion walking through the artic wildlands, with a pariot side-kick",
        uiImage: UIImage( imageLiteralResourceName: "test_img"), showPopUp: .constant(true))
}
