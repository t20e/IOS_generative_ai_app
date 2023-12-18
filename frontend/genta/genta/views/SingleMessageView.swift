//
//  SingleChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct SingleMessageView: View {
    let message : String
    let sentByUser : Bool
    
    var body: some View {
        HStack{
            if sentByUser {
                Spacer()
            }
            Text(message)
                .padding(8)
                .background(.blue)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .listRowSeparator(.hidden)
            //        add the traingle at the bottom right
                .overlay(alignment: sentByUser ? .bottomLeading : .bottomTrailing){
                    Image(systemName: "arrowtriangle.down.fill")
                    //                        .resizable()
                    //                        .frame(width: 30, height: 20)
                        .font(.title)
                    //                        .rotationEffect(.degrees(direction == .left ? 45 : -45))
                        .offset(x: sentByUser ? 5 : -5, y: 15)
                        .foregroundColor(.blue)
                }
            if !sentByUser{
                Spacer()
            }
        }
        .listRowSeparator(.hidden)
            }
}


#Preview {
    SingleMessageView(message: "hello there", sentByUser: true)
}



//old
//Text(message)
//    .padding()
//    .background(.blue)
//    .foregroundColor(.white)
//    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
//    .listRowSeparator(.hidden)
////        add the traingle at the bottom right
//    .overlay(alignment: direction == .left ? .bottomLeading : .bottomTrailing){
//        Image(systemName: "arrowtriangle.down.fill")
//            .font(.title)
//            .rotationEffect(.degrees(direction == .left ? 45 : -45))
//            .offset(x: direction == .left ? -10 : 10, y: 10)
//        //                            .foregroundColor(.blue)
//    }
