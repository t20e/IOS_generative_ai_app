//
//  GeneratedImagesView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct AllGeneratedImgsView: View {
    @EnvironmentObject var user : User
    
    @State var showPopUp = false
    @State var currUiImage : UIImage?
    @State var currPrompt = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    private var randomPaddingHorizontal : [Int] = [15, 20, 10]
    private var randomPaddingVertical : [Int] = [5, 25, 10]
    private var randomImgWidth : [Int] = [75, 85, 95]
    private var randomImgHeight : [Int] = [85, 75, 95]
    
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Spacer()
                    Text("Hey \(user.data.firstName.capitalized)")
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .font(.title3)
                        .background(Color.theme.primColor)
                        .cornerRadius(20)
                        .padding(.trailing, 25)
                        .foregroundColor(
                            colorScheme == .dark ? .black : .white
//                            Color.theme.textColor
                        )
                }
                HStack{
                    Text("Generated images")
                        .foregroundStyle(Color.theme.textColor)
                        .underline()
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 35)
                }
                
                ScrollView{
                    if !user.data.generatedImgs.isEmpty{
                        //                    if !true{
                        ForEach(Array(stride(from: 0, to: user.data.generatedImgs.count, by: 3)), id: \.self) { idx in
                            HStack{
                                ForEach(0 ..< 3) { innerIdx in
                                    if idx + innerIdx < user.data.generatedImgs.count {
                                        let prompt = user.data.generatedImgs[idx + innerIdx].prompt
                                        let data = user.data.generatedImgs[idx + innerIdx].data
                                        
                                        if data != nil{
                                            Image(uiImage:
                                                    (UIImage(data: data!)!)
                                            )
                                            .resizable()
                                            .frame(
                                                width: CGFloat(randomImgWidth.randomElement()!),
                                                height: CGFloat(randomImgHeight.randomElement()!)
                                            )
//                                            .foregroundColor(.red)
                                            .cornerRadius(5)
                                            .padding(EdgeInsets(
                                                top: CGFloat(randomPaddingVertical.randomElement()!),
                                                leading: CGFloat(randomPaddingHorizontal.randomElement()!),
                                                bottom: CGFloat(randomPaddingVertical.randomElement()!),
                                                trailing: CGFloat(randomPaddingHorizontal.randomElement()!)))
                                            .onTapGesture {
                                                currPrompt = prompt
                                                showPopUp = true
                                                currUiImage = UIImage(data: data!)!
                                            }
                                        }
                                    }else{
                                        EmptyImagesView()
                                    }
                                }
                            }
                        }
                    }else{
                        ForEach(0..<3){idx in
                            HStack{
                                ForEach(0..<3){innerIdx in
                                    EmptyImagesView()
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: {showPopUp},
                set: {showPopUp = $0}
            )){
                ImagePopUpView(prompt: currPrompt, uiImage: (currUiImage ?? UIImage(systemName: "shippingbox"))!, showPopUp: $showPopUp)
                    .presentationDetents([.fraction(0.5), .large])
            }
        }
        
    }
}

#Preview {
    AllGeneratedImgsView()
}
