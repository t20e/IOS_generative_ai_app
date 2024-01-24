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
    
    
    @State private var isKeyboardVisible = false // used so that that the view will move up when keyboard appears
    // view KeyboardResponsiveModifier for more info
    
    
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
        /*
         Important: I had an issue using TabView with a .page on it, the keyboard would block the TextField, the soultion
         was to move the view up above the keyboard. view the KeyboardResponsiveModifier file for more info!!
         */
        ScrollViewReader { proxy in // used so that when the keyboard appears it will scroll to the bottom so that it doesnt appear as tho the keyboard is overlapping the TextField
            GeometryReader { geometry in // same as ScrollViewReader
                ScrollView { // same as ScrollViewReader
                    VStack {
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
//                            !isKeyboardVisible ? Spacer() : nil
                            MessageTextInput(
                                canAnimate: $viewModel.canAnimateLoading,
                                textInput: $viewModel.textInput,
                                action: process,
                                placeHolder: $viewModel.placeholder,
                                btnAlreadyClicked: $viewModel.btnAlreadyClicked,
                                isExpandingTextField : true
                            )
                                .id("scrollToId")
                                .padding()
 
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    .onAppear{
                        if user.numImgsGenerated_ >= ALLOWED_FREE_NUM_OF_GENERATED_IMGS {
                            self.viewModel.allowUserToGenerate = false
                        }
                    }
                }
                .keyboardResponsive() // Apply the custom modifier here
                // listen for event that trigger if the keyboard is on screen
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    isKeyboardVisible = true
                    withAnimation {
                        // scrolls to the bottom without this it will show the keyboard overlapping the textField
                        proxy.scrollTo("scrollToId", anchor: .bottom)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    isKeyboardVisible = false
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
