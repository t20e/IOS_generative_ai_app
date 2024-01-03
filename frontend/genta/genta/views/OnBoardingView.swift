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
    @State var messages : [Message] = []
    
//    @Environment(\.colorScheme) var colorScheme
    
    @State var textInput = ""

    var body: some View {
        
        ZStack{
            VStack{
                ChatView(messages: messages)
                
                if !showRegLogin{
                    Button("Sign Up", action: {
                        showRegLogin = true
                        messages.append(Message(text: "Enter your email.", sentByUser: false))
                    })
                    .frame(width: 250, height: 40)
                    .background(Color.theme.primColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    
                    Button("Login", action: {
                        showRegLogin = true
                        isOnLogin = true
                        messages.append(Message(text: "Enter your email.", sentByUser: false))
                    })
                    .frame(width: 250, height: 40)
                    .background(.clear)
                    .foregroundColor(Color.theme.textColor)
                    
                } else {
                    HStack{
                        Button(action: {
                            goBack()
                        }, label: {
                            Text("Go back")
                                .foregroundStyle(Color.theme.primColor)
                            Image(systemName: "arrow.uturn.up.circle")
                                .foregroundColor(Color.theme.primColor)
                        })
                        .padding(.horizontal, 15)
                        
                        Spacer()
                        
                        Button(action: {
                            switchProcess()
                            isOnLogin = !isOnLogin
                        }, label: {
                            Text(isOnLogin ? "Sign Up" : "Login")
                                .foregroundStyle(Color.theme.primColor)
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(Color.theme.primColor)
                            
                        })
                        .padding(.horizontal, 15)
                    }
                    HStack (spacing: 10) {
                        TextField(viewCont.placeholder, text: $textInput)
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.theme.actionColor, lineWidth: 1)
                            )
                            .autocapitalization(.none) //stops the auto capitilize of words
                            .autocorrectionDisabled()
                            .foregroundColor(Color.theme.textColor)
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
                                .foregroundColor(Color.theme.actionColor)
                        })
                        
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            let selectImg = viewCont.exampleGeneratedImages.randomElement()
            messages += [
                Message(text: "Prompt?", sentByUser: false),
                Message(
                    text: selectImg!["prompt"]!,
                sentByUser: true),
                Message(text: "", sentByUser: false, isImg: true, image: Image(selectImg!["imageName"]!))
            ]
        }
    }
    
    func forward_propagate(){
        if viewCont.regProcess == .validatePassword || viewCont.regProcess == .validateConfirmPassword || viewCont.loginProcess == .validatePassword || viewCont.regProcess == .validateCode {
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
            } else if viewCont.regProcess == .validateCode{
                return validateCode()
            }
            else if viewCont.regProcess == .validateAge{
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
    
    func validateCode(){
        //        enter the code that was sent to the users email for validation
//        send email and code
        
        messages.append(Message(text: "Checking code.", sentByUser: false, isLoadingSign: true))
        
        Task{ @MainActor in
            let res = await user.userService.vertifyEmail(email: viewCont.regData.email, code: textInput)
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
                return
            }
            messages.append(Message(text: "Email vertified. Please enter a password.", sentByUser: false))
            viewCont.regProcess = .validatePassword
            viewCont.placeholder = "password"
            textInput = ""
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
                viewCont.regData.email = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
                viewCont.regProcess = .validateCode
                viewCont.placeholder = "enter code"
                textInput = ""
                messages.append(Message(text: res.msg, sentByUser: false))
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
