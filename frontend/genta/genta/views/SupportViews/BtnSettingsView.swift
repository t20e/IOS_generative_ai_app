//
//  SettingsBtnView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

enum WhichPopUp {
    case editProfile, preferences, changePassword, deleteAccount, helpTab
}


struct BtnSettingsView: View {
    let text : String
    @State var showPopUp = false
    var whichPopUp : WhichPopUp
    
    
    var body: some View {
        HStack{
            Text(text)
                .onTapGesture {
                    showPopUp.toggle()
                }
                .popover(isPresented: $showPopUp) {
                    switch whichPopUp {
                        case .editProfile:
                            EditProfileView()
                        case .preferences:
                            EditPreferencesView()
                        case .changePassword:
                            EditPasswordView()
                        case .deleteAccount:
                            DeleteAccountView()
                        case .helpTab:
                            HelpTabView()
                    }
                }
            Spacer()
            Image("rightArrow")
                .resizable()
//            TODO try a
                .frame(width: 6, height: 12)
        }
                .padding(.bottom, 12)
    }
}

#Preview {
    BtnSettingsView(text: "Hello", whichPopUp: .editProfile)
}
