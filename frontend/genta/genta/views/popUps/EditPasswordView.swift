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
    @State var oldPassword = ""
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Change Password")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                Spacer()
            }
            .padding()
            VStack(alignment: .leading){
                Text("Old Password")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                TextField("Password", text: $oldPassword)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            .padding(10)
            
            
            VStack(alignment: .leading){
                Text("New Password")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                TextField("Password", text: $newPassword )
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            }
            .padding(10)
            
            Button(action: {
                print("Chaning password")
                
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
    }
}

#Preview {
    EditPasswordView()
}
