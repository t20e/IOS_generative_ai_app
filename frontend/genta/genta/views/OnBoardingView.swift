//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


struct OnBoardingView: View {
    @EnvironmentObject var user : User
    @ObservedObject var viewCont = LoginRegController()
    @State var isOnLogin = false
    @State var showRegLogin = false
    
    @State var messages : [Message] = [
        Message(text: "Prompt?", sentByUser: false),
        Message(text: "A lion walking on water", sentByUser: true), //TODO ADD IMAGE AND PROMPT
        Message(text: "", sentByUser: false, isImg: true, image: Image("test_img"))
    ]
    
    @State var textInput = ""

    var body: some View {
        
        ZStack{
            VStack{
                ChatView(messages: messages)
                
                if !showRegLogin{
                    Button("Sign Up", action: {
                        //                        viewCont.validateRegisteration(wentBack: false)
                        showRegLogin = true
                        messages.append(Message(text: "Enter your email.", sentByUser: false))
                    })
                    .frame(width: 250, height: 40)
                    .background(Color.theme.primColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    
                    Button("Login", action: {
                        //                        viewCont.validateLogin()
                        showRegLogin = true
                        isOnLogin = true
                        messages.append(Message(text: "Enter your email.", sentByUser: false))
                    })
                    .frame(width: 250, height: 40)
                    .background(Color.theme.backgroundColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    
                } else {
                    HStack{
                        Button(action: {
                            goBack()
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
                            switchProcess()
                            isOnLogin = !isOnLogin
                        }, label: {
                            Text(isOnLogin ? "Sign Up" : "Login")
                            //                        TODO add in forground colors
                            //                            .foregroundStyle(Color.theme.primColor)
                            Image(systemName: "arrow.up.arrow.down")
                            //                            .foregroundStyle(Color.theme.primColor)
                        })
                        .padding(.horizontal, 15)
                    }
                    HStack (spacing: 10) {
                        TextField(viewCont.placeholder, text: $textInput)
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.theme.primColor, lineWidth: 2)
                            )
                            .autocapitalization(.none) //stops the auto capitilize of words
                            .autocorrectionDisabled()
                        Button(action: {
                            if textInput.count < 2 {
                                messages.append(Message(text: "Please enter something.", sentByUser: false, isError: true))
                            } else {
                                forward_propagate()
                            }
                        }, label: {
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                        })
                        
                    }
                    .padding()
                }
            }
        }
    }
    
    func forward_propagate(){
        if viewCont.regProcess == .validatePassword || viewCont.regProcess == .validateConfirmPassword || viewCont.loginProcess == .validatePassword{
            messages.append(Message(text: String(repeating: "*", count: textInput.count), sentByUser: true))
        }else{
            messages.append(Message(text: textInput, sentByUser: true))
        }
        
        if isOnLogin{
            if viewCont.loginProcess == .validatePassword{
                messages.append(Message(text: "Logging in", sentByUser: false))
                viewCont.loginData.password = textInput
                return login()
            }
            let res = viewCont.validateLogin(text: textInput)
            messages.append(res.msg)
        } else {
            if viewCont.regProcess == .validateEmail {
                return checkIfEmailExists()
            } else if viewCont.regProcess == .validateAge{
                return registerUser()
            } else{
                let res = viewCont.validateReg(text: textInput)
                messages.append(res.msg)
            }
        }
        textInput = ""
    }
        
    func registerUser(){
        guard let age = Int(textInput) else {
            return messages.append(Message(text: "Please enter a validate age", sentByUser: false, isError: true))
        }
        if age <= 13{
            return messages.append(Message(text: "Sorry you need to be 13 or older", sentByUser: false, isError: true))
        }
        messages.append(Message(text: "Registering...", sentByUser: false, isLoadingSign: true))
        viewCont.regData.age = age
        Task{ @MainActor in
            let res = await user.register(regData: viewCont.regData)
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
            }else{
                messages.append(Message(text: res.msg, sentByUser: false))
                textInput = ""
            }
        }
    }
    

    func checkIfEmailExists(){
        messages.append(Message(text: "Checking your email.", sentByUser: false, isLoadingSign: true))

        Task{ @MainActor in
            let res = await user.userService.checkIfEmailInDbApiCall(email: textInput)
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
                return
            }else{
                viewCont.regData.email = textInput
                viewCont.regProcess = .validatePassword
                viewCont.placeholder = "password"
                textInput = ""
                messages.append(Message(text: "Please enter a password.", sentByUser: false))
            }
        }
    }

    func login(){
        Task{ @MainActor in
            let res = await user.login(loginData: viewCont.loginData)
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
                return
            }
            messages.append(Message(text: res.msg, sentByUser: false))
        }
    }
    
    
    func goBack(){
        if isOnLogin{
            if viewCont.loginProcess == .validatePassword  {
                viewCont.loginProcess = .validateEmail
                viewCont.placeholder = "email"
                messages.append(Message(text: "Enter your email.", sentByUser: false))
            }else{return} //so it doesnt erase the textInput when still on email
        }else{
            let resMsg = viewCont.regGoBackward()
            messages.append(resMsg)
        }
        textInput = ""
    }
    
    func switchProcess(){
        let resMsg = viewCont.switchTo(isOnLogin: isOnLogin)
        messages.append(resMsg)
        textInput = ""
    }
    
}

#Preview {
    OnBoardingView()
}
