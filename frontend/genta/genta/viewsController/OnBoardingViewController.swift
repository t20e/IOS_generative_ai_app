//
//  LoginViewController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation



class OnBoardingViewController: RegLoginController{

    override init() {}
    
    func goBackward(){
        if isCurrentlyReg{
            regGoBackward()
        }else{
            loginGoBackward()
        }
    }
    
    func switchTo(){
//        switches between login and registration
        if isCurrentlyReg{
//            switch to login
            messages.append(Message(text: "Login", sentByUser: false, isError: false))
            isCurrentlyReg = false
            currValidatingLogin = .startprocess
            validateLogin()
        }else{
            messages.append(Message(text: "Sign Up", sentByUser: false, isError: false))
            isCurrentlyReg = true
            currValidatingReg = .startProcess
            validateRegisteration(wentBack: false)
        }
    }
    
    func loginGoBackward(){
        if currValidatingLogin == .validatePassword  {
            currValidatingLogin = .startprocess
            isOnSecureField = false
            validateLogin()
        }else{
            messages.append(Message(text: "Sorry cant go backward", sentByUser: false, isError: true))
        }
    }
    
    func regGoBackward(){
        switch currValidatingReg{
//            moves backward from whatever it is currently validatation
            case .startProcess:
//                messages.append(Message(text: "Sorry cant go backward", sentByUser: false))
                return
            case .validateEmail:
                messages.append(Message(text: "Sorry cant go backward", sentByUser: false, isError: true))
                return
            case .validatePassword:
                inputFieldText = ""
                currValidatingReg = .startProcess
            case .validateConfirmPassword:
                inputFieldText = regData.email
                currValidatingReg = .validateEmail
            case .validateFirstName:
                inputFieldText = regData.password
                currValidatingReg = .validatePassword
            case .validateLastName:
            inputFieldText = regData.password
                currValidatingReg = .validateConfirmPassword
            case .validateAge:
            inputFieldText = regData.firstName
                currValidatingReg = .validateFirstName
            }
            validateRegisteration(wentBack: true)
    }
}
