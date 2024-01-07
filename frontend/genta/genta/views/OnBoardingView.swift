//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import SwiftData


struct OnBoardingView: View {

    @ObservedObject private var viewModel = OnBoardingViewModel()
    
    @Environment(\.modelContext) private var context
//    @Query private var users : [User] //can just read first name for the user
    
    
    
    var body: some View {
        ZStack{
            VStack{
                ChatView(messages: $viewModel.messages)
                
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
                        placeHolder: $viewModel.placeholder
                    )
                    .padding()
                }
            }
        }
        .onChange(of: viewModel.executeProcess, finalProcess)
    }
    
    /*
        IMPORTANT: I could not figure out how to use swiftData outside of views, and I'm pretty sure you cant;
        so to register/login and save the users data, I put the reg/login in the view rather than in the viewModel
        so that swiftData could be used. The viewModel control's the view's UI except for final login/reg
     */
        
    func register(){
        viewModel.messages.append(Message(text: "Registering...", sentByUser: false, isLoadingSign: true, imageData: nil))
        Task{ @MainActor in
            let res = await AuthServices.register(regData: viewModel.regData)
            await viewModel.stopAnimation()
            viewModel.executeProcess = .none
            if res.err{
                viewModel.messages.append(Message(text: res.msg, sentByUser: false, isError: res.err, imageData: nil))
                viewModel.regProcess = .validateEmail
                return
            }
            viewModel.messages.append(Message(text: res.msg, sentByUser: false, imageData: nil))
            viewModel.textInput = ""
            print("returned user to view", res)
            await delay(seconds: 0.5)
            PersistenceManager.shared.saveUser(user: res.user!, context: context)
        }
    }
 
    func login(){
        Task{ @MainActor in
            let res = await AuthServices.login(loginData: viewModel.loginData)
            await viewModel.stopAnimation()
            viewModel.executeProcess = .none
            if res.err{
                viewModel.loginProcess = .validateEmail
                return viewModel.messages.append(Message(text: res.msg, sentByUser: false, isError: res.err, imageData: nil))
            }
            viewModel.messages.append(Message(text: res.msg, sentByUser: false, imageData: nil))
            viewModel.textInput = ""
            await delay(seconds: 0.5)
            PersistenceManager.shared.saveUser(user: res.user!, context: context)
            PersistenceManager.shared.deleteAll(context: context)
        }
    }
    
    func process(){
        /* 
             I was getting a warning that since OnboardingViewModel had a @MainActor it
             will be removed when passing the viewModel.forward_propagate to the MessageTextInput()
         */
            viewModel.forward_propagate()
    }

    func finalProcess(){
        if viewModel.executeProcess == .none{
            return // becuase of the .onChange this will run even if the executeProcess == .none so we exit out
        }
        viewModel.executeProcess == .register ? register() : login()
    }
      
    
}

#Preview {
    OnBoardingView()
//        .modelContainer(for: User.self)
}
