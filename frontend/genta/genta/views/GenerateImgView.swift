//
//  GenerateView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI
import CoreData

struct GenerateImgView: View {
    @Environment(\.managedObjectContext) var context

    @ObservedObject private var viewModel = ImageGenerateViewModel()
    
    let user : CDUser
    @FetchRequest var messages: FetchedResults<CDMessage>
    
    init(user: CDUser) {
        self.user = user
        _messages = FetchRequest<CDMessage>(
            entity: CDMessage.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \CDMessage.timestamp, ascending: true)],
            predicate: NSPredicate(format: "cduser == %@", user),
            animation: .default)
    }
    
    var body: some View {
            VStack{
                //IMPORTANT I could not figure out how to just grab the users.messages it wouln't
                //refresh when I add messages to the user
                ChatView(messages: Array(messages))
                MessageTextInput(
                    canAnimate: $viewModel.canAnimateLoading,
                    textInput: $viewModel.textInput,
                    action: process,
                    //                    messages: $viewModel.messages,
                    placeHolder: .constant("prompt"),
                    btnAlreadyClicked: $viewModel.btnAlreadyClicked
                )
                .padding()
                .onAppear{
                    print("reloading generate view")
                    if user.messages.count == 0{
                        // insert the first message
                        PersistenceController.shared.addMsg(msg: Message(text: "What would you like to generate?", sentByUser: false, imageData:  nil), user: user)
                    }
                }
            }
    }
    
    func process(){
        // i needed to pass the user to the viewModel func
        viewModel.generateImg(user: user)
    }
    
}

//#Preview {
//    return GenerateImgView()
//}
