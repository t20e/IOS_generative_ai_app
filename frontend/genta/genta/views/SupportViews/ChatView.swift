//
//  ChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


struct ChatView: View {
    @Binding var messages : [Message]
    
    var body: some View {
        ScrollView{
            ScrollViewReader { proxy in
                VStack{
                    ForEach(Array(messages.enumerated()), id: \.element.id) { idx, msg in
                        SingleMessageView(
                            message: msg.text,
                            sentByUser: msg.sentByUser,
                            isError: msg.isError,
                            isImg: msg.isImg,
                            imageData: msg.imageData,
                            isLoadingSign: msg.isLoadingSign,
                            isRevisedPrompt: msg.isRevisedPrompt,
                            canAnimateImg: msg.canAnimateImg,
                            textAlreadyAnimated : msg.textAlreadyAnimated
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
        Message( text: "s2", sentByUser: false, imageData:  nil),
        Message(text: "end", sentByUser: false, imageData: nil),
        Message(text: "their", sentByUser: false, imageData: nil)
        
    ]))
}
