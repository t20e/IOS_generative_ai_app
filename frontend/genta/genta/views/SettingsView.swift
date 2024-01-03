//
//  SettingsView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var user : User

    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Settings")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .bold()
                .foregroundStyle(Color.theme.textColor)
                .padding(.bottom, 25)
            HStack{
                Image(systemName: "person.crop.circle")
                Text("Account")
                    .bold()
                    .foregroundStyle(Color.theme.textColor)
            }
            Divider()
                .padding(.top, -5)
                .padding(.bottom, 12)

//            BtnSettingsView(texwt: "Edit Profile", whichPopUp: .editProfile)
            
//            BtnSettingsView(text: "Preferences", whichPopUp: .preferences)

            BtnSettingsView(text: "Change Password", whichPopUp: .changePassword)

            BtnSettingsView(text: "Delete Account", whichPopUp: .deleteAccount)
            
            BtnSettingsView(text: "Help", whichPopUp: .helpTab)
            
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("loggin user out")
                    user.logout()
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
