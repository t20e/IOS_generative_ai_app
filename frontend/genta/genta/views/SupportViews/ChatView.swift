//
//  ChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import SwiftData

struct ChatView: View {
    var messages : [CDMessage]
        
    var body: some View {
        ScrollView{
            ScrollViewReader { proxy in
                VStack{
                    ForEach(messages, id: \.id) { msg in
                        SingleMessageView(
                            message: msg.text,
                            sentByUser: msg.sentByUser,
                            isError: msg.isError,
                            isImg: msg.isImg,
                            imageData: msg.imageData,
                            isLoadingSign: msg.isLoadingSign,
                            isRevisedPrompt: msg.isRevisedPrompt,
                            alreadyAnimated : msg.alreadyAnimated,
                            id : msg.id
                        )
                        .padding([.top, .bottom, .horizontal], 15)
                        .onAppear {
                            scrollToBottom(proxy: proxy)
                        }
                        .onChange(of: messages){
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
                .padding(.bottom, 10)
            }
        }
        .cornerRadius(20)
    }    
    
    func scrollToBottom(proxy: ScrollViewProxy){
        DispatchQueue.main.async{
            withAnimation {
                proxy.scrollTo(messages[messages.endIndex - 1].id, anchor: .bottom)
            }
        }
    }
    
}

#Preview {
    
    let messages : [CDMessage] = []
    return ChatView(messages: messages)
}
