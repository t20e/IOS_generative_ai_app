//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


struct IntroView: View {
    @ObservedObject var viewCon = IntroViewController()
     
    var body: some View {
        VStack{
           
            ChatView(messages: viewCon.messages)
            
            if !viewCon.actionBtnClicked {
                Button("Sign Up", action: {
                    viewCon.actionBtnClicked = true
                    viewCon.loginProcess()
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.primColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)

                Button("Login", action: {
                    viewCon.actionBtnClicked = true
                    viewCon.loginProcess()
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.backgroundColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)

            } else {
                
                HStack{
                    Button(action: {
                        viewCon.goBackward()
                    }, label: {
                        Text("Go back")
//                        TODO add in forground colors
//                            .foregroundStyle(Color.theme.primColor)
                        Image(systemName: "arrow.uturn.up.circle")
//                            .foregroundStyle(Color.theme.primColor)
                    })
                    .padding(.horizontal, 15)
                    Spacer()
                }
                
                HStack (spacing: 10) {
                    if viewCon.isOnSecureField {
                        SecureField(viewCon.currFieldPlaceholder, text: $viewCon.inputFieldText)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.theme.primColor, lineWidth: 2)
                            )
                            .autocapitalization(.none) 
                            .autocorrectionDisabled()
                    } else {
                        TextField(viewCon.currFieldPlaceholder, text: $viewCon.inputFieldText)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.theme.primColor, lineWidth: 2)
                        )
                        .autocapitalization(.none) //stops the auto capitilize of words
                        .autocorrectionDisabled()
                    }


                    Button(action: {
//                        send whatever data is in the text field to the intro controller
                        viewCon.inputFieldText.count < 2 ? viewCon.messages.append(Message(text: "Please enter something.", sentByUser: false)) : viewCon.loginProcess()
                    }, label: {
                        Image(systemName: "arrow.up.circle")
//                        MARK - make image a litter bigger
                    })
                }
                .padding()
            }
                }
    }
}

#Preview {
    IntroView()
}
