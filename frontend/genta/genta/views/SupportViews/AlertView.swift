//
//  AlertView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct AlertView: View {
    @State var msg : String
    @EnvironmentObject var user : User

    var body: some View {
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
            }, label: {
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 35, height: 35)
            })
        }
        
    }
}

#Preview {
    AlertView(msg: "Your session has expired, please log back in")
}
