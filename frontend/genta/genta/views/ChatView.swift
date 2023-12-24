//
//  ChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct Message: Hashable, Identifiable {
    let id = UUID()
    let text: String
    let sentByUser: Bool
    let isError : Bool
}

struct ChatView: View {
    var messages : [Message]
    var body: some View {
            ScrollView{
                ScrollViewReader { proxy in
                    VStack{
//                        TODO MAKE sure text doesnt streat out the entir page
                        ForEach(messages, id:\.id){ msg in
                            SingleMessageView(message: msg.text, sentByUser: msg.sentByUser, isError: msg.isError)
                                .padding([.top, .bottom, .horizontal], 10)
                        }
                    }
                    .onChange(of: messages) {
                    DispatchQueue.main.async{
                        withAnimation {
                            proxy.scrollTo(messages[messages.endIndex - 1].id, anchor: .bottom)
                        }
                    }
                }
                }
        }
    }
}

#Preview {
    ChatView(messages: 
                [Message( text: "s2", sentByUser: false, isError: false),
                        Message(text: "end", sentByUser: false, isError: false),
                 Message(text: "their", sentByUser: false, isError: false)
                       
                       ])
}
