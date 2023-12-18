//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct IntroView: View {
    @StateObject var viewController = LoginViewController()
    @State var actionBtnClicked = false
    @State var textField = ""
    @State var secureTextFeild = ""
    @State var currFieldPlaceholder = "email"
    
    var body: some View {
        VStack{
            ChatView(messages: viewController.toUserMsgs)
            if !actionBtnClicked {
                Button("Sign Up", action: {
                    viewController.regHandler()
                    actionBtnClicked = true
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.primColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                
                
                Button("Login", action: {
                    viewController.loginHandler()
                    actionBtnClicked = true
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.backgroundColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)
            } else {
                HStack (spacing: 10) {
                    if viewController.isOnSecureField{
                        SecureField("Password", text: $secureTextFeild)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.theme.primColor, lineWidth: 2)
                            )
                    } else {
                        TextField(currFieldPlaceholder, text: $textField, onEditingChanged: { isEditing in
                            if !isEditing{
                                print("text field here")
                            }
                        })
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.theme.primColor, lineWidth: 2)
                        )
                        .autocapitalization(.none) //stops the auto capitilize of words
                        .autocorrectionDisabled()
                    }
                    Image(systemName: "arrow.up.circle")
                        .padding()
                }
                .padding()
            }
        }
        }
}


#Preview {
    IntroView()
}
