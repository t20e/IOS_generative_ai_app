//
//  ChangePasswordView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

struct EditPasswordView: View {
    @EnvironmentObject var user : User
    @State var newPassword = ""
    @State var showPasswordField = false
    @State var code = ""
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    Text("Change Password")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .bold()
                    Spacer()
                }
                .padding()
                if showPasswordField{
                    VStack(alignment: .leading){
                        Text("Code")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        TextField("code", text: $code)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding(10)
                    
                    VStack(alignment: .leading){
                        Text("New Password")
                            .foregroundStyle(.gray)
                            .font(.footnote)
                        TextField("Password", text: $newPassword )
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding(10)
                }
                Button(action: {
                    if !showPasswordField{
                        showPasswordField = true
                        //                    TODO send code to email and make alert that email was sent
                        getCode()
                    } else if showPasswordField {
                        showAlert = false
                        print("Changing password")
                        changePassword()
                    }
                }, label: {
                    HStack{
                        Text("Update password")
                            .foregroundStyle(.white)
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(.red)
                    .cornerRadius(20)
                })
                Spacer()
            }
            if showAlert{
                AlertView(msg: alertMsg, showAlert: $showAlert)
            }
        }
    }
    func getCode(){
        Task{@MainActor in
            let res = await user.userService.getCode(email: user.data.email, token: user.getAccessToken())
            alertMsg = res.msg
            showAlert = true
        }
    }
    
    func changePassword(){
//        needs the users email witht the old password and new password
        Task{@MainActor in
            let res = await user.userService.changePassword(email: user.data.email, code: code, newPassword: newPassword, token: user.getAccessToken())
            alertMsg = res.msg
            showAlert = true
            if !res.err{
                showPasswordField = false
            }
        }
    }
    
}

#Preview {
    EditPasswordView()
}
