//
//  IntroView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

//to view views that have enivoment objects passed in inside the preview on the view() add .environentObkect(the model here)

struct OnBoardingView: View {
    @EnvironmentObject var user: User
    @ObservedObject var viewModel = LoginRegController()
    @State var isOnLogin = false
    @State var showRegLogin = false
    @State var messages: [Message] = []
    @State var textInput = ""
    @State var canAnimateLoading = false
    
    var body: some View {
        
        ZStack{
            VStack{
                ChatView(messages: $messages)
                
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
                    
                    
                    MessageTextInput(
                        canAnimate: $canAnimateLoading,
                        textInput: $textInput,
                        action: forward_propagate,
                        messages: $messages,
                        placeHolder: $viewModel.placeholder.wrappedValue
                    )
                    .padding()
                }
            }
        }
        .onAppear{
            let selectImg = viewModel.exampleGeneratedImages.randomElement()
            messages += [
                Message(text: "Prompt?", sentByUser: false),
                Message(
                    text: selectImg!["prompt"]!,
                    sentByUser: true),
                Message(text: "", sentByUser: false, isImg: true, image: Image(selectImg!["imageName"]!))
            ]
        }
    }
    func startWaitingAnimation(){
        canAnimateLoading = true
    }
    func stopAnimation() async {
        do{
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Sleep for 2 seconds
        }catch{
            print("Setting task.sleep error, \(error)")
        }
        removeLoadingLastIndex()
        canAnimateLoading = false

    }
    
    func removeLoadingLastIndex(){
        //        removes the loading sign of the last index of the messages array
        if let lastIndex = messages.indices.last {
            // Update the last item
            messages[lastIndex].isLoadingSign = false
        }
    }
    
    func forward_propagate(){
        if textInput.count < 2 {
            return messages.append(Message(text: "Please enter something.", sentByUser: false, isError: true))
        }
        

        
        if viewModel.regProcess == .validatePassword || viewModel.regProcess == .validateConfirmPassword || viewModel.loginProcess == .validatePassword || viewModel.regProcess == .validateCode {
            messages.append(Message(text: String(repeating: "*", count: textInput.count), sentByUser: true))
        }else{
            messages.append(Message(text: textInput, sentByUser: true))
        }
        
        if isOnLogin{
            if viewModel.loginProcess == .validatePassword{
                messages.append(Message(text: "Logging in", sentByUser: false))
                startWaitingAnimation()
                viewModel.loginData.password = textInput
                return login()
            }
            let res = viewModel.validateLogin(text: textInput)
            messages.append(res.msg)
        } else {
            if viewModel.regProcess == .validateEmail {
                startWaitingAnimation()
                return checkIfEmailExists()
            } else if viewModel.regProcess == .validateCode{
                startWaitingAnimation()
                return validateCode()
            }
            else if viewModel.regProcess == .validateAge{
                startWaitingAnimation()
                return registerUser()
            } else{
                let res = viewModel.validateReg(text: textInput)
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
        viewModel.regData.age = age
        Task{ @MainActor in
            let res = await user.register(regData: viewModel.regData)
            await stopAnimation()
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
            let res = await user.userService.vertifyEmail(email: viewModel.regData.email, code: textInput)
            await stopAnimation()
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
                return
            }
            messages.append(Message(text: "Email vertified. Please enter a password.", sentByUser: false))
            viewModel.regProcess = .validatePassword
            viewModel.placeholder = "password"
            textInput = ""
        }
    }
    
    func checkIfEmailExists(){
        messages.append(Message(text: "Checking your email.", sentByUser: false, isLoadingSign: true))
        
        Task{ @MainActor in
            let res = await user.userService.checkIfEmailInDbApiCall(email: textInput)
            await stopAnimation()
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
                return
            }else{
                viewModel.regData.email = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.regProcess = .validateCode
                viewModel.placeholder = "enter code"
                textInput = ""
                messages.append(Message(text: res.msg, sentByUser: false))
            }
        }
    }
    
    func login(){
        Task{ @MainActor in
            let res = await user.login(loginData: viewModel.loginData)
            await stopAnimation()
            if res.err{
                messages.append(Message(text: res.msg, sentByUser: false, isError: res.err))
                return
            }
            messages.append(Message(text: res.msg, sentByUser: false))
        }
    }
    
    
    func goBack(){
        if isOnLogin{
            if viewModel.loginProcess == .validatePassword  {
                viewModel.loginProcess = .validateEmail
                viewModel.placeholder = "email"
                messages.append(Message(text: "Enter your email.", sentByUser: false))
            }else{return} //so it doesnt erase the textInput when still on email
        }else{
            let resMsg = viewModel.regGoBackward()
            messages.append(resMsg)
        }
        textInput = ""
    }
    
    func switchProcess(){
        let resMsg = viewModel.switchTo(isOnLogin: isOnLogin)
        messages.append(resMsg)
        textInput = ""
    }
    
}

#Preview {
    OnBoardingView()
}
