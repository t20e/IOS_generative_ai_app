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
                Spacer()
                Text("Edit Profile")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                Spacer()
            }
            .padding()
                VStack(alignment: .leading){
                    Text("First Name")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    TextField(user.data.firstName.capitalized, text: $firstname)
//                    TextField("Firstname", text: $firstname)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .padding(10)
                VStack(alignment: .leading){
                    Text("Last Name")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    TextField(user.data.lastName.capitalized, text: $lastname)
//                    TextField("Firstname", text: $firstname)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                .padding(10)
            HStack{
                VStack(alignment: .leading){
                    Text("Age")
                        .foregroundStyle(.gray)
                        .font(.footnote)
                    TextField(String(user.data.age), text: $age)
//                    TextField("Firstname", text: $firstname)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
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
