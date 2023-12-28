//
//  GenerateView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct ImageGenerateView: View {
    
    @EnvironmentObject var user : User
    @ObservedObject var viewCont = ImageGenerateViewController()
    
    @State var inputText = ""
    
    var body: some View {
        VStack{
            ChatView(messages: viewCont.messages)

            HStack(spacing: 25){
                TextField("Prompt", text: $inputText)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.theme.primColor, lineWidth: 2)
                            .padding(4)
                    )

                Button(action: {
                    print("hello")
                }, label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                .padding(.trailing, 15)
            }
        }
        .padding()
    }
}

#Preview {
    ImageGenerateView()
}
