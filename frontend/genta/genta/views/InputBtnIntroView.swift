//
//  TextInputIntroView.swift
//  genta
//
//  Created by Tony Avis on 12/24/23.
//

import SwiftUI

struct InputBtnIntroView: View {
    @ObservedObject var viewCont : OnBoardingViewController
    
    var body: some View {
        HStack{
            Button(action: {
                 viewCont.goBackward()
            }, label: {
                Text("Go back")
//                        TODO add in forground colors
//                            .foregroundStyle(Color.theme.primColor)
                Image(systemName: "arrow.uturn.up.circle")
//                            .foregroundStyle(Color.theme.primColor)
            })
            .padding(.horizontal, 15)
            
            Spacer()
            
            Button(action: {
                 viewCont.switchTo()
            }, label: {
                Text(viewCont.isCurrentlyReg ? "Login" : "Sign Up")
//                        TODO add in forground colors
//                            .foregroundStyle(Color.theme.primColor)
                Image(systemName: "arrow.up.arrow.down")
//                            .foregroundStyle(Color.theme.primColor)
            })
            .padding(.horizontal, 15)
        }
        
        HStack (spacing: 10) {
            if viewCont.isOnSecureField {
                SecureField(viewCont.currFieldPlaceholder, text: $viewCont.inputFieldText)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.theme.primColor, lineWidth: 2)
                    )
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            } else {
                TextField(viewCont.currFieldPlaceholder, text: $viewCont.inputFieldText)
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
                viewCont.inputFieldText.count < 2 ? viewCont.messages.append(Message(text: "Please enter something.", sentByUser: false, isError: true)) : viewCont.isCurrentlyReg ? viewCont.validateRegisteration(wentBack: false) : viewCont.validateLogin()
            }, label: {
                Image(systemName: "arrow.up.circle")
//                        MARK - make image a litter bigger
            })
        }
    }
}

#Preview {
    InputBtnIntroView(viewCont: OnBoardingViewController())
}
