//
//  GeneratedImagesView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct GeneratedImagesView: View {
    @EnvironmentObject var user : User
    
    @State var showPopUp = false
    @State var currUiImage : UIImage?
    @State var currPrompt = ""
    
    private var randomPaddingHorizontal : [Int] = [15, 20, 10]
    private var randomPaddingVertical : [Int] = [5, 25, 10]
    private var randomImgWidth : [Int] = [75, 85, 95]
    private var randomImgHeight : [Int] = [85, 75, 95]
    
    var body: some View {
        ZStack{
            VStack {
                
                Text("Generated images")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 75, leading: 25, bottom: 15, trailing: 0))
                ScrollView{
                    if !user.data.generatedImgs.isEmpty{
                        
                        ForEach(Array(stride(from: 0, to: user.data.generatedImgs.count, by: 3)), id: \.self) { idx in
                            HStack{
                                ForEach(0 ..< 3) { innerIdx in
                                    if idx + innerIdx < user.data.generatedImgs.count {
                                        let prompt = user.data.generatedImgs[idx + innerIdx].prompt
                                        let data = user.data.generatedImgs[idx + innerIdx].data
                                        
                                        if data != nil{
                                            Button(action: {
                                                // when user clicks an image show pop up for the iamge
                                                currPrompt = prompt
                                                currUiImage = UIImage(data: data!)!
                                                showPopUp = true
                                            }, label: {
                                                Image(uiImage:
                                                        (UIImage(data: data!)!)
                                                )
                                                .resizable()
                                                .frame(
                                                    width: CGFloat(randomImgWidth.randomElement()!),
                                                    height: CGFloat(randomImgHeight.randomElement()!)
                                                )
                                                .foregroundColor(.blue)
                                                .cornerRadius(5)
                                                .padding(EdgeInsets(
                                                    top: CGFloat(randomPaddingVertical.randomElement()!),
                                                    leading: CGFloat(randomPaddingHorizontal.randomElement()!),
                                                    bottom: CGFloat(randomPaddingVertical.randomElement()!),
                                                    trailing: CGFloat(randomPaddingHorizontal.randomElement()!)))
                                            })
                                        }
                                    }
                                }
                            }
                            
                        }
                    }else{
                        Text("No Images")
                    }
                }
            }
            .sheet(isPresented: $showPopUp) {
                OneImageView(prompt: currPrompt, uiImage: (currUiImage ?? UIImage(systemName: "shippingbox"))!, showPopUp: $showPopUp)
                    .presentationDetents([.fraction(0.5), .large])
            }
            
        }
    }
}

#Preview {
    GeneratedImagesView()
}
