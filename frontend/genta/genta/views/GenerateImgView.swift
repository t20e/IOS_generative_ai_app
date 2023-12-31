//
//  GenerateView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI
import SwiftData

struct GenerateImgView: View {
    
    @ObservedObject var viewCont = ImageGenerateViewController()
    
//    var messages : [Message] = [
//        Message(text: "What would you like to generate?", sentByUser: false, imageData:  nil)
//    ]
//
    @State var textInput = ""
    @State var canAnimateLoading  = false
    @State var alreadyGenerating = false
    
    @Environment(\.modelContext) private var context
    @Query private var users: [User]
//    @Bindable var user : User? {users.first}
    
    var user: User {
        if let firstUser = users.first {
            return firstUser
        } else {
            return User(id: "", email: "", firstName: "", lastName: "", age: 0, numOfImgsGenerated: 0, generatedImgs: [], accessToken: "")
        }
    }
    

    let generateQuestions : [String] = [
//        TODO how can i set the first item in the msgs array to something like "What would you like to generate?"
        "What would you like to generate next?",
        "Tell me, what kind of content do you want to generate?",
        "Ready to create something new? What's your choice?",
        "Feeling creative? What should I generate for you?",
        "What type of content is on your mind?",
        "The possibilities are endless! What do you want to generate?",
        "Let's brainstorm! What should be the next thing I create?",
        "Eager to generate! What's your preference this time?",
        "Curious to know—what would you like me to generate for you?",
    ]

    var body: some View {
        VStack{
            ForEach(users){ user in
                @Bindable var user = user
//                when this boots up check if the users msg array is emprt and then append this messages
//                user.messages.append(Message(text: "What would you like to generate?", sentByUser: false, imageData:  nil))
                ChatView(messages: $user.messages)
            }
            
//            MessageTextInput(
//                canAnimate: $canAnimateLoading,
//                textInput: $textInput,
//                action: generateImg,
//                messages: $messages,
//                placeHolder: "Prompt"
//            )
        }
        .padding()
        .onAppear{
            if user.messages.count == 0{
                // insert the first message
                let msg = Message(text: "What would you like to generate?", sentByUser: false, imageData:  nil)
                context.insert(msg)
            }
            
            print("reloading generate view")
        }
    }
    
//    func startWaitingAnimation(){
//        canAnimateLoading = true
//    }
//    func stopAnimation() async {
////        do{
////            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Sleep for 2 seconds
////        }catch{
////            print("Setting task.sleep error, \(error)")
////        }
//        removeLoadingLastIndex()
//        canAnimateLoading = false
//        alreadyGenerating = false
//    }
//    
//    func removeLoadingLastIndex(){
//        //        removes the loading sign of the last index of the messages array
//        if let lastIndex = messages.indices.last {
//            // Update the last item
//            messages[lastIndex].isLoadingSign = false
//        }
//    }
//    
//    
//    func generateImg(){
//        
//        if textInput.count < 15 {
//            messages.append(Message(text: "Please enter a longer prompt!", sentByUser: false, isError: true))
//            return
//        }
//        if alreadyGenerating{
//            return
//        }
//        
//        startWaitingAnimation()
//        let textCopy = textInput
//        
//        messages.append(Message(text: textInput, sentByUser: true, isLoadingSign: true))
//        textInput = ""
//        
//        if user.data.numOfImgsGenerated <= ALLOWED_FREE_NUM_OF_GENERATED_IMGS{
//            Task{ @MainActor in
//                let res = await user.imageServices.generateImgApiCAll(prompt: textCopy, token: user.getAccessToken())
//                await stopAnimation()
//                if res.err{
//                    return messages.append(Message(text: res.msg ?? "Issue getting error messages, please try later.", sentByUser: false, isError: true))
//                }
//                user.data.generatedImgs.append(GeneratedImgsStruct(imgId: res.data!.imgId, prompt: res.data!.prompt, presignedUrl: res.data!.presignedUrl))
//                await user.addOneImage(idx: user.data.generatedImgs.count - 1)
//                let newImg = user.data.generatedImgs[user.data.generatedImgs.count - 1]
//                
//                //       if it wasnt revised than don't append to messages
//                if newImg.prompt.hasPrefix("REVISED###") {
//                    messages.append(Message(text: newImg.prompt, sentByUser: true, isRevisedPrompt:true))
//                }
//                messages += [
//                    Message(text: "", sentByUser: false, isImg: true, image: Image(uiImage: UIImage(data: newImg.data!)!)),
//                    Message(text: generateQuestions.randomElement()!, sentByUser: false)
//                ]
//                user.data.numOfImgsGenerated += 1
//            }
//        }else{
//            print("User has generated more than the free amount")
//            return messages.append(Message(text: "Sorry, you have exceeding the free limit for image generation.", sentByUser: false, isError: true))
//        }
//    }
    
    
}

#Preview {
    GenerateImgView()
}
