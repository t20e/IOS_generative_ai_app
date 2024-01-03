//
//  OneImageView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct ImagePopUpView: View {
    @State var prompt : String
    @State var uiImage : UIImage
    @Binding var showPopUp : Bool
    
    var body: some View {
        
        if showPopUp{
            ZStack {
                GeometryReader { geometry in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .cornerRadius(10)
                }
                
                VStack {
                    Spacer()
                    VStack {
                        Text(filterMsg(prompt: prompt))
                            .font(.subheadline)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                        Button(action: {
                            saveImage()
                        }) {
                            Image("downloadArrow")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(8)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 40)
            }
            .ignoresSafeArea()
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
    ImagePopUpView(
        prompt: "REVISED###A lion walking through the artic wildlands, with a pariot side-kick",
        uiImage: UIImage( imageLiteralResourceName: "test_img"), showPopUp: .constant(true))
}
