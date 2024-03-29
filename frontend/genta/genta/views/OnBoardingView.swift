//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import SwiftData


struct OnBoardingView: View {

    
    @Environment(\.managedObjectContext) var context
    @ObservedObject private var viewModel = OnBoardingViewModel()
    
    var body: some View {
        VStack{
            ChatView(messages: viewModel.messages)
            if !viewModel.showRegLogin{
                Button("Sign Up", action: {
                    viewModel.showRegLogin = true
                    viewModel.isOnLogin = false
                    viewModel.addMsg(msg: Message(text: "Enter your email.", sentByUser: false, imageData: nil))
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.primColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                
                Button("Login", action: {
                    viewModel.showRegLogin = true
                    viewModel.isOnLogin = true
                    viewModel.addMsg(msg: Message(text: "Enter your email.", sentByUser: false, imageData: nil))
                    
                    // so the user can change from resetting password to just loggin in
                    viewModel.loginData = LoginData()
                    viewModel.isResettingPassword = false
                })
                .frame(width: 250, height: 40)
                .background(.clear)
                .foregroundColor(Color.theme.textColor)
                
            } else {
                if viewModel.isOnLogin{
                    // To reset the password on the login view
                    Button(action: {
                        viewModel.isResettingPassword = true
                        viewModel.addMsg(msg: Message(text: "To reset your password, please enter your email.", sentByUser: false, imageData: nil))
                        viewModel.loginProcess = .validateEmail
                        viewModel.loginData = LoginData()
                    }, label: {
                        Text("Reset password")
                            .foregroundStyle(Color.theme.primColor)
                            .underline()
                    })
                }
                
                HStack{
                    Button(action: {
                        viewModel.switchTo()
                    }, label: {
                        Text(viewModel.isOnLogin ? "Sign Up" : "Login")
                            .foregroundStyle(Color.theme.primColor)
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(Color.theme.primColor)
                        
                    })
                    .padding(.horizontal, 15)
                    
                    Spacer()
                    Button(action: {
                        viewModel.goBack()
                    }, label: {
                        Text("Go back")
                            .foregroundStyle(Color.theme.primColor)
                        Image(systemName: "arrow.uturn.up.circle")
                            .foregroundColor(Color.theme.primColor)
                    })
                    .padding(.horizontal, 15)
                }
                MessageTextInput(
                    canAnimate: $viewModel.canAnimateLoading,
                    textInput: $viewModel.textInput,
                    action: process,
                    placeHolder: $viewModel.placeholder,
                    btnAlreadyClicked: $viewModel.btnAlreadyClicked,
                    isExpandingTextField : false
                )
                .padding()
            }
        }
    }

  
    func process(){
        /* 
             I was getting a warning that since OnboardingViewModel had a @MainActor it
             will be removed when passing the viewModel.forward_propagate to the MessageTextInput()
         */
            viewModel.forward_propagate()
    } 
    
}

#Preview {
    return OnBoardingView()
}
