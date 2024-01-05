//
//  AlertView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct AlertView: View {
    
    @State var msg : String
    @Binding var showAlert  : Bool
    @Binding var isMajorAlert : Bool
    @State var animate = false
    @State var action : () -> Void
    
    var body: some View {
        if showAlert{
            ContentShape{
                GeometryReader { geometry in
                    VStack{
                        HStack{
                            Image(systemName: isMajorAlert ? "exclamationmark.triangle" : "exclamationmark.warninglight")
                                .foregroundColor(Color.theme.textColor)
                                .padding(.horizontal, 8)
                            Text(msg)
                                .font(.subheadline)
                                .padding(10)
                                .foregroundColor(Color.theme.textColor)
                                .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.theme.primColor)
                                )
                        }
                        .scaleEffect(animate ? 1 : 0)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill( isMajorAlert ? Color.theme.errColor : Color.theme.actionColor )
                        )
                        .frame(width: geometry.size.width, height:
                                animate ? geometry.size.height / 2 : 0)
                    }
                }
            }
            .onAppear{
                withAnimation(.spring()){
                    animate = true
                }
            }
                .onTapGesture {
                    showAlert = false
                    action()
                }
        }
    }
}

#Preview {
    AlertView(msg: "Your session has expired", showAlert: .constant(true), isMajorAlert: .constant(true), action: {})
}
