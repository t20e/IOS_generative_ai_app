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
    @State var showPrompt = false
    @State var showAlert = false
    @State var alertMsg = ""
    @State var isMajorAlert = false
    @Environment(\.colorScheme) var colorScheme

    
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
                .blur(radius: showAlert ? 5 : 0)
                
                VStack {
                    Spacer()
                    
                    HStack() {
                        Text(
                            showPrompt ? filterMsg(prompt: prompt) :
                                "See Prompt"
                        )
                        .font(.subheadline)
                        .padding(5)
                        .foregroundColor(.white)
                    }
                    .background(Color.theme.actionColor)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 10,
                            topTrailingRadius: 10
                        )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        withAnimation {
                            showPrompt.toggle()
                        }
                    }
                    
                    Button(action: {
                        saveImage()
                    }) {
                        Image(
                            colorScheme == .dark ? "downloadArrowDark" : "downloadArrowWhite"
                        )
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color.theme.actionColor)
                        .cornerRadius(10)
                        .padding(.top, 50)
                    }
                }
                .padding(.bottom, 40)
                .blur(radius: showAlert ? 5 : 0)
                if showAlert{
                    AlertView(msg: alertMsg, showAlert: $showAlert, isMajorAlert: $isMajorAlert, action: {})
                }
            }
            .ignoresSafeArea()
        }
    }
    
    
    func saveImage(){
        let imageSaver = ImageSaver()
        imageSaver.successHandler={
            alertMsg = "Saved image to photo album"
            isMajorAlert = false
            showAlert = true
            print("Successfully saved image to users photo album")
        }
        imageSaver.errorHandler = {
            alertMsg = "Issue saving image, please try later."
            isMajorAlert = true
            showAlert = true
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
