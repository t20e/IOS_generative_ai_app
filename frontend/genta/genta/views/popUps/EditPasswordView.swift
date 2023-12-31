//
//  ChangePasswordView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

struct EditPasswordView: View {
    @EnvironmentObject var user : User
    @State var password = ""
    @State var oldPassword = ""
    
    
    var body: some View {
        VStack{
            TextField("Enter your old password", text: $oldPassword)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .frame(width: UIScreen.main.bounds.width / 1.5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                        .background(Color.white)
                )
                .padding(.bottom, 20)
            TextField("Enter your password", text: $password)
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .frame(width: UIScreen.main.bounds.width / 1.5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                        .background(Color.white)
                )
                .padding(.bottom, 20)
        }
        Button(action: {
            print("Chaning password")
            
        }, label: {
            HStack{
                Image(systemName: "delete.forward")
                    .foregroundColor(.white)
                Text("Delete account!")
                    .foregroundStyle(.white)
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(.red)
            .cornerRadius(20)
        })
    }
}

#Preview {
    EditPasswordView()
}
