//
//  HelpTabPopUpsView.swift
//  genta
//
//  Created by Tony Avis on 12/31/23.
//

import SwiftUI

struct HelpTabPopUpsView: View {
//    @EnvironmentObject var user : User

    @Binding var whichPopup : HelpPopUp
    @State var header = ""
    @State var textbody = ""
    @State var supportTextInput = "" //    the users input for support
    @State var showAlert = false
    @State var alertMsg = ""
    @State var isMajorAlert = false
    
    var body: some View {
        ZStack{
            VStack(){
                HStack{
                    Text(header)
                        .underline(true, color: .gray)
                    Spacer()
                }
                HStack{
                    if whichPopup == .contactUs{
                        VStack{
                            Text("What do you need support with?")
                            //TODO fix this its not sending back to server
                            TextField("Enter text, 250 characters limit", text: $supportTextInput, axis: .vertical)
                                .padding()
                                .border(.gray, width: 1)
                                .lineLimit(5...8)
                                .onChange(of: supportTextInput) { newValue, transaction in
                                    if newValue.count > 250 {
                                        supportTextInput = String(newValue.prefix(250))
                                    }
                                }
                            Button(action: {
//                                getSupport()
                            }, label: {
                                Text("Send")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.primColor))                            })
                        }
                    }else{
                        Text(textbody)
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
            .onAppear{
                setData()
            }
            .blur(radius: showAlert ? 5 : 0)
            if showAlert{
                AlertView(msg: alertMsg, showAlert: $showAlert, isMajorAlert: $isMajorAlert, action: {})
            }
        }
    }
    
    func setData(){
        switch whichPopup {
            case .contactUs:
                header = "Contact Us"
            case .whyPromptRevised:
                header = "Why are prompts revised?"
                textbody = "• When you send a generation request to DALL·E, it will automatically re-write it for safety reasons, and to add more detail (because more detailed prompts generally result in higher quality images)."
            case .howToChangeToDarkMode:
                header = "How to change to dark mode?"
                textbody = "• To switch to dark mode, navigate to your Apple settings and enable the dark mode option."
            case .none:
                return
        }
    }
    
//    func getSupport(){
//        Task{ @MainActor in
//            let res = await user.userService.getSupport(token: user.getAccessToken(), issue: supportTextInput)
//            print("support msg",res)
//            showAlert = true
//            if res.err{
//                isMajorAlert = true
//                alertMsg = "Sorry ran into a problem sending your issure, please try again later."
//                return
//            }
//            isMajorAlert = false
//            alertMsg = "Issue recieved, we will get back to you shortly."
//        }
//    }
    
}

#Preview {
    HelpTabPopUpsView(whichPopup: .constant(.contactUs))
}
