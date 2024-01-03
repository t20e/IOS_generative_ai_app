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
                Spacer()
                Text(msg)
                    .font(.subheadline)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 40, trailing: 5))
                    .foregroundColor(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.cyan)
                    )
                    .shadow(color: Color.gray.opacity(0.9), radius: 30, x: 0, y: 0)
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 40, height: 40)
                    .offset(y: -30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 5)
                            .background(.clear)
                            .offset(y: -30)
                    )
                    .background(
                        Circle()
                            .fill(Color.white)
                            .offset(y: -30)
                    )
                    .onTapGesture {
                        showAlert = false
                    }
                Spacer()
                Spacer()
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { timer in
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
