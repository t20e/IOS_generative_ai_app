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
    /* 
        I had the viewModel as a @ObservedObject like the class is but I got a weird bug where when I change the
        canAnimateLoading in the viewModel it wouldnt change it in the MessageTextInput view nested in this view
    */
    @StateObject private var viewModel: ImageGenerateViewModel
    let user: CDUser
    @FetchRequest var messages: FetchedResults<CDMessage>

    init(user: CDUser) {
        self.user = user
        // wrapped the ImageGenerateViewModel: ObservableObject into a StateObject im still not sure as to why changes
        // weren't being published when it was just a @ObservedObject variable
        self._viewModel = StateObject(wrappedValue: ImageGenerateViewModel())
        
        let fetchRequest: NSFetchRequest<CDMessage> = CDMessage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CDMessage.timestamp, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "cduser == %@", user)
        self._messages = FetchRequest(fetchRequest: fetchRequest)
    }
 
    
    var body: some View {
        VStack{
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
                    placeHolder: .constant("prompt"),
                    btnAlreadyClicked: $viewModel.btnAlreadyClicked
                )
                .padding()
            }
        }
        .onAppear{
            if user.numImgsGenerated_ >= ALLOWED_FREE_NUM_OF_GENERATED_IMGS {
                self.viewModel.allowUserToGenerate = false
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
