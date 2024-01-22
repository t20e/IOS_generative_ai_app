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
        if user.numImgsGenerated_ >= ALLOWED_FREE_NUM_OF_GENERATED_IMGS {
            viewModel.allowUserToGenerate = false
        }
    }
    
    var body: some View {
        VStack{
            //IMPORTANT I could not figure out how to just grab the users.messages it wouln't
            //refresh when I add messages to the user
            ChatView(messages: Array(messages))
                .onAppear{
                    print("reloading generate view")
                    if user.messages.count == 0{
                        // insert the first message
                        if viewModel.allowUserToGenerate{
                            _ = PersistenceController.shared.addMsg(msg: Message(text: "What would you like to generate?", sentByUser: false, imageData:  nil), user: user)
                        }else{
                            _ = PersistenceController.shared.addMsg(msg: Message(text: "You have exceeding the free limit for image generation.", sentByUser: false, isError: true, imageData: nil), user: user)
                        }
                    }
                }
            if viewModel.allowUserToGenerate{
                MessageTextInput(
                    canAnimate: $viewModel.canAnimateLoading,
                    textInput: $viewModel.textInput,
                    action: process,
                    //                    messages: $viewModel.messages,
                    placeHolder: .constant("prompt"),
                    btnAlreadyClicked: $viewModel.btnAlreadyClicked
                )
                .padding()
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
