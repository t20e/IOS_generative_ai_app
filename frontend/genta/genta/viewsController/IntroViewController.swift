//
//  LoginViewController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation



class IntroViewController: RegLoginController{

    
    @Published var actionBtnClicked = false
    @Published var currIdx = 0
    @Published var isOnSecureField = false
    @Published var currFieldPlaceholder = "email"
//    bool for whether or not the user is current registering or login ing
    @Published var isCurrentlyReg : Bool = false
    @Published var inputFieldText : String = ""
    
    @Published var messages : [Message] = [
        Message(text: "Prompt", sentByUser: false),
        Message(text: "A lion walking on water", sentByUser: true),
    ]
    override init() {}
    
//    private var loginCon = LoginController()
//    private var regCon = RegController()

    func loginProcess(){
        var res = (LoginToIntroControllerMsg(err: false, msg: "", isNextFieldSecure: false), Message(text: "", sentByUser: false))
        if isCurrentlyReg {
            //            sent data to the regCon
            //            res = regCon.register(text: inputFieldText)
            print("registering")
        } else {
            //send data to the login con
//            res = loginCon.validateLogin(text: inputFieldText)
            res = validateLogin(text: inputFieldText)
        }
        //  1 is for the return struct from loginControll and 2 for what ever the user typed in
        if !res.0.err {
            inputFieldText = "" //empty input field
        }
        
        if res.0.isNextFieldSecure{
            isOnSecureField = true
        }
        if res.1.text.count > 1{
            messages.append(Message(text: res.1.text, sentByUser: true))
        }
        messages.append(Message(text: res.0.msg, sentByUser: false))
    }
    
    func goBackward(){
        if isCurrentlyReg{
//            BUG when i enter password and get error than try to go back to the email it wont scroll the view down automatically
        }else{
            let wentBack = loginCon.loginGoBackward()
            isOnSecureField = false
            wentBack ? loginProcess() : nil

        }
    }
}
