//
//  EditProfileView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var user : User

    @State var firstname = ""
    @State var lastname = ""
    @State var age = ""

    var body: some View {
        VStack{
            HStack{
                Text("Edit Profile")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                Spacer()
            }
                VStack(alignment: .leading){
                    Text("First Name")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    TextField(user.data.firstName.capitalized, text: $firstname)
                    Divider()
                        .padding(.top, -5)
                        .padding(.bottom, 12)
                }
                .padding(10)
                VStack(alignment: .leading){
                    Text("Last Name")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    TextField(user.data.lastName.capitalized, text: $lastname)
                    Divider()
                        .padding(.top, -5)
                        .padding(.bottom, 12)
                }
                .padding(10)
            HStack{
                VStack(alignment: .leading){
                    Text("Age")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    TextField(String(user.data.age), text: $age)
                    Divider()
                        .padding(.top, -5)
                        .padding(.bottom, 12)
                }
                .padding(10)
                Spacer()
            }
            Spacer()
            
            Button(action: {
                print("Updaing user")
            }, label: {
                Text("Update")
                    .foregroundStyle(.white)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(.red)
                    .cornerRadius(20)
                
            })
        }
        .padding()
    }
}

#Preview {
    EditProfileView()
}
