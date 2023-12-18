//
//  LoginViewController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation

class LoginViewController: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var errMsg = ""
    @Published var toUserMsgs: [Message] = [
        Message(text: "Prompt", sentByUser: false),
        Message(text: "A lion running on water", sentByUser: true),
    ]
    @Published var isOnSecureField = false
    
    init(){}
    
    func login(){
        
    }
    private func validateLogin() ->Bool{
        return true
    }
    
    func loginHandler(){
//        when user clicks the login button path this will start
        toUserMsgs.append(Message( text: "What is your email?", sentByUser: false))
    }
    func regHandler(){
//        when user clicks the reg button path this will start
        print("reg handler")
    }
    
}
