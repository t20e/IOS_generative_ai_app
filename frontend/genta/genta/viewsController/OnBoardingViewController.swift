//
//  LoginViewController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation



class OnBoardingViewController: RegLoginController{

        
    override init() {}

    func loginProcess(){
        if isCurrentlyReg {
            //            sent data to the regCon
            //            res = regCon.register(text: inputFieldText)
            print("registering")
        } else {
            //send data to the login con
            validateLogin()
        }

    }
    
    func goBackward(){
        if isCurrentlyReg{
//            BUG when i enter password and get error than try to go back to the email it wont scroll the view down automatically
        }else{
            let wentBack = loginGoBackward()
            isOnSecureField = false
            wentBack ? loginProcess() : nil

        }
    }
}
