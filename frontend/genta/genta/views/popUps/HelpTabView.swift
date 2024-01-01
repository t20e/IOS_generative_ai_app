//
//  HelpTabView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

enum HelpPopUp {
    case none, contactUs, whyPromptRevised
}

struct HelpTabView: View {
    @State var showPopup = false
    @State var whichPopup = HelpPopUp.none
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Spacer()
                    Text("Help & Support")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding()
                ContentShape{
                    HStack{
                        Text("Contact us")
                        Spacer()
                        Image(systemName: whichPopup == .contactUs ? "plus" : "minus")
                            .rotationEffect(Angle(degrees: whichPopup == .contactUs ? 0 : 360))
                            .animation(.easeInOut, value: whichPopup)
                    }
                }
                .onTapGesture {
                    showPopup = true
                    whichPopup = .contactUs
                }
                Divider()
                ContentShape{
                    HStack{
                        Text("Why are prompts revised")
                        Spacer()
                        Image(systemName: whichPopup == .whyPromptRevised ? "plus" : "minus")
                            .rotationEffect(Angle(degrees: whichPopup == .whyPromptRevised ? 0 : 360))
                            .animation(.easeInOut, value: whichPopup)

                    }
                }
                .onTapGesture {
                    showPopup = true
                    whichPopup = .whyPromptRevised
                }
                Divider()
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showPopup) {
            HelpTabPopUpsView(whichPopup: $whichPopup)
                .presentationDetents([.medium, .large])
                .onDisappear {
                    showPopup = false
                    whichPopup = .none
                }
        }
    }
}

#Preview {
    HelpTabView()
}
