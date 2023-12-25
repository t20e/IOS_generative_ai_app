//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


struct OnBoardingView: View {
//    @EnvironmentObject var userServices : UserServices
    @EnvironmentObject var user : User
    @ObservedObject var viewCont = OnBoardingViewController()
    
    var body: some View {
        VStack{
            ChatView(messages: viewCont.messages)
            
            if !viewCont.actionBtnClicked {
                Button("Sign Up", action: {
                    viewCont.actionBtnClicked = true
                    viewCont.validateRegisteration(wentBack: false)
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.primColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)

                Button("Login", action: {
                    viewCont.actionBtnClicked = true
                    viewCont.validateLogin()
                })
                .frame(width: 250, height: 40)
                .background(Color.theme.backgroundColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)

            } else {
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
                        if viewCont.inputFieldText.count < 2 {
                            viewCont.messages.append(Message(text: "Please enter something.", sentByUser: false, isError: true))
                        }else if viewCont.isCurrentlyReg{
                            viewCont.validateRegisteration(wentBack: false)
                            viewCont.canReg ? registerUser() : nil
                        }
                        else{ 
                            viewCont.validateLogin()
                            viewCont.canLogin ? loginUser() : nil
                        }
                    }, label: {
                        Image(systemName: "arrow.up.circle")
                        //                        MARK - make image a litter bigger
                    })
                }
                    .padding()
            }
        }
    }
    
    func registerUser(){
        Task{ @MainActor in
            let res = await user.register(regData: viewCont.regData)
            if res.err{
                viewCont.canReg = false
                viewCont.currValidatingReg = .startProcess
                viewCont.validateRegisteration(wentBack: false)
                viewCont.messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
            }else{
                viewCont.messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
            }
        }
    }
    
    func loginUser(){
        Task{ @MainActor in
            let res = await user.login(loginData: viewCont.loginData)
            if res.err{
                viewCont.canLogin = false
                viewCont.currValidatingLogin = .startprocess
                viewCont.validateLogin()
                viewCont.messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
            }else{
                viewCont.messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
            }
        }
    }
}

#Preview {
    OnBoardingView()
}
