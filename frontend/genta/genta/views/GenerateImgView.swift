//
//  GenerateView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI
import CoreData

struct GenerateImgView: View {
    
    @ObservedObject private var viewModel = ImageGenerateViewModel()
    
    @FetchRequest(
        entity: CDUser.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isCurrUser_ == %@", NSNumber(value: true)),
        animation: .default)
    private var users: FetchedResults<CDUser>
    
        @FetchRequest(
            entity: CDMessage.entity(),
            sortDescriptors: [],
            //        predicate: NSPredicate(format: "user == %@", NSNumber(value: true)),
            animation: .default)
        private var messages: FetchedResults<CDMessage>
    
    
    var body: some View {
        if let user = users.first {
            VStack{
                //IMPORTANT I could not figure out how to just grab the users.messages it wouln't
                //refresh when I add messages to the user
                ChatView(messages: Array(messages))
                MessageTextInput(
                    canAnimate: $viewModel.canAnimateLoading,
                    textInput: $viewModel.textInput,
                    action: viewModel.startLoadingAnimation,
                    //                    messages: $viewModel.messages,
                    placeHolder: .constant("prompt"),
                    btnAlreadyClicked: $viewModel.btnAlreadyClicked
                )
                .padding()
                .onAppear{
                    print("reloading generate view")
                    if user.messages.count == 0{
                        // insert the first message
                        viewModel.addMsg(msg: Message(text: "What would you like to generate?", sentByUser: false, imageData:  nil), user: user)
                    }
                }
                //                .onDisappear{
                //                    //TODO this wont run if the user exits out app from this view
                //                    //when the user swipes the view make all images and texts no longer able to be animated
                //                    for (index, msg) in user.messages.enumerated() {
                //                        // Modify the value
                //                        msg.textAlreadyAnimated = true
                //                        msg.isLoadingSign = false
                //                        // Update the value in the array
                //                        user.messages[index] = msg
                //                    }
                //                }
            }
        }
    }
}

#Preview {
    return GenerateImgView()
}
