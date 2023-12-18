//
//  LoginView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


struct LoginView: View {
   
    @StateObject var viewController = LoginViewController()
    
    var msg = ""
    
    var body: some View {
//        VStack{
//            ChatView(messages: messages)
//            TextField("prompt", text: $viewController.email)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .textFieldStyle(DefaultTextFieldStyle())
//                        .autocapitalization(.none) //stops the auto capitilize of words
//                        .autocorrectionDisabled()
//            SecureField("Password", text: $viewController.password)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                .textFieldStyle(DefaultTextFieldStyle())
//                }
        Text("he")
        }
    }


#Preview {
    LoginView()
}
