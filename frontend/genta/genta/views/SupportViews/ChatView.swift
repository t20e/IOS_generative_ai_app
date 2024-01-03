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
    var isLoadingSign : Bool
    let isImg : Bool
    let image : Image
    let isRevisedPrompt: Bool
    
    init(text: String, sentByUser: Bool, isError: Bool = false, isLoadingSign: Bool = false, isImg: Bool = false, image: Image = Image(systemName: "character.textbox"),  isRevisedPrompt : Bool = false) {
        self.text = text
        self.sentByUser = sentByUser
        self.isError = isError
        self.isLoadingSign = isLoadingSign
        self.isImg = isImg
        self.image = image
        self.isRevisedPrompt = isRevisedPrompt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
//        this makes the ids conform to Hashable
    }
    
}

struct ChatView: View {
    var messages : [Message]
    var body: some View {
            ScrollView{
                ScrollViewReader { proxy in
                    VStack{
//                        TODO MAKE sure text doesnt streat out the entir page
                        ForEach(messages, id:\.id){ msg in
//                            SingleMessageView(message: msg.text, sentByUser: msg.sentByUser, isError: msg.isError, isLoadingSign: msg.isLoadingSign)
                            SingleMessageView(message: msg.text, sentByUser: msg.sentByUser, isError: msg.isError, isImg: msg.isImg, image: msg.image, isLoadingSign: msg.isLoadingSign, isRevisedPrompt: msg.isRevisedPrompt)
                                .padding([.top, .bottom, .horizontal], 10)
                        }
                    }
                    .padding(.bottom, 15)
                    .onChange(of: messages) {
                    DispatchQueue.main.async{
                        withAnimation {
                            proxy.scrollTo(messages[messages.endIndex - 1].id, anchor: .bottom)
                        }
                    }
                }
            }
        }
            .cornerRadius(20)
    }
}

#Preview {
    ChatView(messages: 
                [Message( text: "s2", sentByUser: false),
                        Message(text: "end", sentByUser: false),
                 Message(text: "their", sentByUser: false)
                       
                       ])
}
