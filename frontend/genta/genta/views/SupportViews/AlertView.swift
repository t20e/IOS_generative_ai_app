//
//  AlertView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct AlertView: View {
    
    @State var msg : String
//    @EnvironmentObject var user : User
    @Binding var showAlert  : Bool

    var body: some View {
        if showAlert{
            VStack{
                Text(msg)
                    .padding(6)
                    .background( .blue)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 15)
                Button(action: {
                    //                withAnimation {
                    //                    user.tokenExpired = false
                    //                }
                    showAlert = false
                }, label: {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: 35, height: 35)
                })
            }        
            .onAppear {
                // Set a timer with a 3-second delay
                Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { timer in
                    // Update the state variable to show the text after the timeout
                    if showAlert{
                        showAlert = false
                    }
                }
            }
        }
        
    }
}

#Preview {
    AlertView(msg: "Your session has expired, please log back in", showAlert: .constant(true))
}
