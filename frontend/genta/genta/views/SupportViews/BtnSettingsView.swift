//
//  SettingsBtnView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

enum WhichPopUp {
    case editProfile, preferences, changePassword, deleteAccount
}


struct BtnSettingsView: View {
    let text : String
//    let action : () -> Void
//    @Binding var showPopUp : Bool
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
                    }
                }
            Spacer()
            Image(systemName: "arrow.right")
        }
                .padding(.bottom, 12)
    }
}

#Preview {
    BtnSettingsView(text: "Hello", whichPopUp: .editProfile)
}
