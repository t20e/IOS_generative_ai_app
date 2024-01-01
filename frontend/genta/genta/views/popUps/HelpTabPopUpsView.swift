//
//  HelpTabPopUpsView.swift
//  genta
//
//  Created by Tony Avis on 12/31/23.
//

import SwiftUI

struct HelpTabPopUpsView: View {
    @EnvironmentObject var user : User

    @Binding var whichPopup : HelpPopUp
    @State var header = ""
    @State var textbody = ""
//    the users input for support
    @State var supportTextInput = ""
        
    var body: some View {
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
                            getSupport()
                        }, label: {
                            Text("Send")
                                .foregroundStyle(.green)
                                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                .background(RoundedRectangle(cornerRadius: 10))
                        })
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
    }
    
    func setData(){
        switch whichPopup {
            case .contactUs:
                header = "Contact Us"
            case .whyPromptRevised:
                header = "Why are prompts revised?"
                textbody = "When you send a generation request to DALL·E, it will automatically re-write it for safety reasons, and to add more detail (because more detailed prompts generally result in higher quality images)."
            case .none:
                return
        }
    }
    
    func getSupport(){
        Task{ @MainActor in
            let res = await user.userService.getSupport(token: user.getAccessToken(), issue: supportTextInput)
        }
    
    }
}

#Preview {
    HelpTabPopUpsView(whichPopup: .constant(.contactUs))
}
