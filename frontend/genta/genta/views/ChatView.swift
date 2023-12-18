//
//  ChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct Message: Hashable {
//    let id : String
    let text: String
    let sentByUser: Bool
}

struct ChatView: View {
    var messages : [Message]
    
    //    TODO add in the right angel arrow for image generateion
    var body: some View {
            List(messages, id: \.self){ msg in
                SingleMessageView(message: msg.text, sentByUser: msg.sentByUser)
                    .padding(.bottom, 5)
            }
            .listStyle(.plain)
    }
}

#Preview {
    ChatView(messages: [Message( text: "start", sentByUser: false),
                        Message(text: "end", sentByUser: false),
                        Message(text: "their", sentByUser: false)
                       
                       ])
}
