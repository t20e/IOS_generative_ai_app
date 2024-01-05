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
    var canAnimateImg : Bool
    var textAlreadyAnimated : Bool
    
    init(text: String, sentByUser: Bool, isError: Bool = false, isLoadingSign: Bool = false, isImg: Bool = false, image: Image = Image(systemName: "character.textbox"),  isRevisedPrompt : Bool = false, canAnimateImg: Bool = false, textAlreadyAnimated:Bool = false
    ) {
        self.text = text
        self.sentByUser = sentByUser
        self.isError = isError
        self.isLoadingSign = isLoadingSign
        self.isImg = isImg
        self.image = image
        self.isRevisedPrompt = isRevisedPrompt
        self.canAnimateImg = canAnimateImg
        self.textAlreadyAnimated = textAlreadyAnimated
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
//        this makes the ids conform to Hashable
    }
    
}

struct ChatView: View {
    @Binding var messages : [Message]
    
    var body: some View {
            ScrollView{
                ScrollViewReader { proxy in
                    VStack{
                        ForEach(Array(messages.enumerated()), id: \.element.id) { idx, msg in
                            SingleMessageView(message: msg.text, sentByUser: msg.sentByUser, isError: msg.isError, isImg: msg.isImg, image: msg.image, isLoadingSign: msg.isLoadingSign, isRevisedPrompt: msg.isRevisedPrompt, canAnimateImg: msg.canAnimateImg, textAlreadyAnimated : msg.textAlreadyAnimated
                                )
                                .padding([.top, .bottom, .horizontal], 15)
                                .onAppear {
                                    if  msg.isImg {
                                        withAnimation {
                                            messages[idx].canAnimateImg = true
                                        }
                                    }
                                    if !msg.sentByUser{
                                        messages[idx].textAlreadyAnimated = true
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 10)
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
    
    func waitingPeriod(){
//        wait for sometime before do the next thing
        Task{@MainActor in
            do{
                try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Sleep for 2 seconds
            }catch{
                print("Setting task.sleep error, \(error)")
            }
        }
    }
    
}

#Preview {
    ChatView( messages: .constant([
                Message( text: "s2", sentByUser: false),
                        Message(text: "end", sentByUser: false),
                 Message(text: "their", sentByUser: false)
                       
                       ]))
}
