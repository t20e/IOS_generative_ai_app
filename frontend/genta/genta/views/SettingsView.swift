//
//  SettingsView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Settings")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .padding(.bottom, 25)
            HStack{
                Image(systemName: "person.crop.circle")
                Text("Account")
                    .bold()
            }
            Divider()
                .padding(.top, -5)
                .padding(.bottom, 12)

            HStack{
                Text("Edit Profile")
//                TODO change to tab arrow pointeing right
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 12)

            HStack{
                Text("Perferences")
//                TODO change to tab arrow pointeing right
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 12)

            HStack{
                Text("Change Password")
//                TODO change to tab arrow pointeing right
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 12)

            HStack{
                Text("Delete Account")
//                TODO change to tab arrow pointeing right
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 12)
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("loggin user out")
                }, label: {
                    Text("Log Out")
                })
                .frame(width: 150, height: 40)
                .background(Color.theme.primColor)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                
                
                
                Spacer()
            }
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    SettingsView()
}
