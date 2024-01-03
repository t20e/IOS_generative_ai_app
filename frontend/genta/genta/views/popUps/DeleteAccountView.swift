//
//  DeleteAccountView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var user : User
    @State var showTextField = false
    @State var password = ""
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        ZStack{
            VStack{
                Text("Warning:")
                    .font(.headline)
                    .padding(.bottom, 15)
                Text("Permanently removing your account will result in the irreversible deletion of all your generated images and data. Once the account is deleted, retrieval of any information will not be possible.")
                    .padding(.bottom, 50)
                if showTextField{
                    HStack(alignment: .center){
                        TextField("Enter your password", text: $password)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .frame(width: UIScreen.main.bounds.width / 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                                    .background(Color.white)
                            )
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding(.bottom, 20)
                }
                Button(action: {
                    if !showTextField{
                        showTextField = true
                    } else if !password.isEmpty{
                        print("deleting account")
                        deleteAccount()
                    }
                    
                }, label: {
                    HStack{
                        Image(systemName: "delete.forward")
                            .foregroundColor(.white)
                        Text( !password.isEmpty ? "Delete account!" : "Confirm")
                            .foregroundStyle(.white)
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(.red)
                    .cornerRadius(20)
                })
            }
            .padding()
            if showAlert{
                AlertView(msg: alertMsg, showAlert: $showAlert)
            }
        }
    }
    
    func deleteAccount(){
        Task{@MainActor in
            let res = await user.userService.deleteAccount(email: user.data.email, password: password, token: user.getAccessToken())
            alertMsg = res.msg
            showAlert = true
            if !res.err{
                user.logout()
            }
        }
    }
    
}

#Preview {
    DeleteAccountView()
}
