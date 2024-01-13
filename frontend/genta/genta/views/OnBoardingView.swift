//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import SwiftData


struct OnBoardingView: View {

    
//    @Environment(\.managedObjectContext) var context
    @ObservedObject private var viewModel = OnBoardingViewModel()

    var body: some View {
        ZStack{
            VStack{
                ChatView(messages: viewModel.messages)
                if !viewModel.showRegLogin{
                    Button("Sign Up", action: {
                        viewModel.showRegLogin = true
                        viewModel.isOnLogin = false
                        viewModel.messages.append(Message(text: "Enter your email.", sentByUser: false, imageData: nil))
                    })
                    .frame(width: 250, height: 40)
                    .background(Color.theme.primColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    
                    Button("Login", action: {
                        viewModel.showRegLogin = true
                        viewModel.isOnLogin = true
                        viewModel.messages.append(Message(text: "Enter your email.", sentByUser: false, imageData: nil))
                    })
                    .frame(width: 250, height: 40)
                    .background(.clear)
                    .foregroundColor(Color.theme.textColor)
                    
                } else {
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
                        messages: $viewModel.messages,
                        placeHolder: $viewModel.placeholder,
                        btnAlreadyClicked: $viewModel.btnAlreadyClicked
                    )
                    .padding()
                }
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
//
//    func finalProcess(){
//        if viewModel.executeProcess == .none{
//            return // becuase of the .onChange this will run even if the executeProcess == .none so we exit out
//        }
//        viewModel.executeProcess == .register ? viewModel.register(context: context) : viewModel.login(context: context)
//    }
//      
    
}

#Preview {
    return OnBoardingView()
}
