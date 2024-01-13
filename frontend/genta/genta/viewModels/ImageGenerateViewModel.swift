//
//  GenerateViewController.swift
//  genta
//
//  Created by Tony Avis on 12/28/23.
//

import Foundation

class ImageGenerateViewModel: ObservableObject{
    
    @Published var textInput = ""
    @Published var canAnimateLoading = false
    @Published var btnAlreadyClicked : Bool
    
    init(textInput: String = "", canAnimateLoading: Bool = false, btnAlreadyClicked: Bool = false) {
        self.textInput = textInput
        self.canAnimateLoading = canAnimateLoading
        self.btnAlreadyClicked = btnAlreadyClicked
    }
    
//    func generateImg(user: User){
//
//        if textInput.count < 15 {
//            let msg = Message(text: "Please enter a longer prompt!", sentByUser: false, isError: true, imageData: nil)
////            PersistenceManager.shared.addMessage(message: msg, user: user)
//            return
//        }
//        if alreadyGenerating{
//            return
//        }
//        startWaitingAnimation()
//        let textCopy = textInput
//
////        PersistenceManager.shared.addMessage(
////            message: Message(text: textInput, sentByUser: true, isLoadingSign: true, imageData: nil),
////            user: user)
//
//        textInput = ""
//        Task{ @MainActor in
//            await delay(seconds: 5.0)
//            await stopAnimation()
//        }
//        return Void()//TODO
//
//
//        if user.numImgsGenerated <= ALLOWED_FREE_NUM_OF_GENERATED_IMGS{
//            Task{ @MainActor in
//                let res = await ImageServices.shared.generateImg(prompt: textCopy, token: user.accessToken)
//                await stopAnimation()
//                if res.err{
//                    let msg = Message(text: res.msg ?? "Issue getting error messages, please try later.", sentByUser: false, isError: true, imageData: nil)
////                    PersistenceManager.shared.addMessage(message: msg, user: user)
//                    return
//                }
//                let downloadImgRes = await ImageServices.shared.downLoadImage(presignedUrl: res.data!.presignedUrl)
//                if downloadImgRes == nil {
//                    //                        TODO somethign went wrong let user know
//                }
////                user.generatedImgs.append(GeneratedImgsStruct(imgId: res.data!.imgId, prompt: res.data!.prompt, presignedUrl: res.data!.presignedUrl, data: downloadImgRes))
//                if res.data!.prompt.hasPrefix("REVISED###") {
//                    //add the prompt only if it was revised by dall-e
////                    PersistenceManager.shared.addMessage(message: Message(text: res.data!.prompt, sentByUser: true, imageData: nil, isRevisedPrompt: true), user: user)
//                }
//                // add the image to the prompt
////                PersistenceManager.shared.addMessage(message: Message(text: "", sentByUser: false, isImg: true, imageData: downloadImgRes), user: user)
//
//                //add the next what would you like to generate msg for user
////                PersistenceManager.shared.addMessage(message:  Message(text: generateQuestions.randomElement()!, sentByUser: false, imageData: nil), user: user)
//
//                user.numImgsGenerated += 1
//
//            }
//        }else{
//            print("User has generated more than the free amount")
////            PersistenceManager.shared.addMessage(message: Message(text: "Sorry, you have exceeding the free limit for image generation.", sentByUser: false, isError: true, imageData: nil), user: user)
//
//        }
//    }
//
//
//    func startWaitingAnimation(){
//        canAnimate = true
//    }
//
//    func stopAnimation() async {
//        canAnimate = false
//        alreadyGenerating = false
//    }
//
//
//    let generateQuestions : [String] = [
//        //        TODO how can i set the first item in the msgs array to something like "What would you like to generate?"
//        "What would you like to generate next?",
//        "Tell me, what kind of content do you want to generate?",
//        "Ready to create something new? What's your choice?",
//        "Feeling creative? What should I generate for you?",
//        "What type of content is on your mind?",
//        "The possibilities are endless! What do you want to generate?",
//        "Let's brainstorm! What should be the next thing I create?",
//        "Eager to generate! What's your preference this time?",
//        "Curious to know—what would you like me to generate for you?",
//    ]

    
}
