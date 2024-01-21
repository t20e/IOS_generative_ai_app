//
//  ChangePasswordView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

struct EditPasswordView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: CDUser.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isCurrUser_ == %@", NSNumber(value: true)),
        animation: .default)
    private var users: FetchedResults<CDUser>
    
    @State var newPassword = ""
    @State var showPasswordField = false
    @State var btnText = "Get code"
    @State var code = ""
    @State var showAlert = false
    @State var alertMsg = ""
    @State var  isMajorAlert = false // this is to either show the alert with a red or orange message indicating how much the user should care for it
    
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
                        TextField("new password", text: $newPassword )
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding(10)
                    
                    // button to get new code
                    Text("Get new code")
                        .onTapGesture {
                            getCode()
                        }
                        .underline()
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
                
                
                Button(action: {
                    if !showPasswordField{
                        showPasswordField = true
                        btnText = "Update Password"
                        getCode()
                    } else if showPasswordField {
                        showAlert = false
                        print("Changing password")
                        changePassword()
                    }
                }, label: {
                    HStack{
                        Text(btnText)
                            .foregroundStyle(.white)
                    }
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(Color.theme.primColor)
                    .cornerRadius(20)
                })
                Spacer()
            }
            .padding()
            .blur(radius: showAlert ? 5 : 0)
            if showAlert{
                AlertView(msg: alertMsg, showAlert: $showAlert, isMajorAlert: $isMajorAlert, action: {})
            }
        }
    }

    func getCode(){
        if let user = users.first {
            Task{@MainActor in
                let res = await AuthServices.shared.getCode(email: user.email, firstName: user.firstName, accessToken: user.accessToken)
                alertMsg = res.msg
                showAlert = true
                isMajorAlert = false
            }
        }
    }

    func changePassword(){
        if let user = users.first {
            Task{@MainActor in
                let res = await AuthServices.shared.changePassword(email: user.email, code: code, newPassword: newPassword, token: user.accesToken)
                alertMsg = res.msg
                showAlert = true
                isMajorAlert = false
                if !res.err{
                    showPasswordField = false
                    isMajorAlert = true
                }
            }
        }
    }
    
}

#Preview {
    EditPasswordView()
}
