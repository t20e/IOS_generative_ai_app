//
//  GenerateViewController.swift
//  genta
//
//  Created by Tony Avis on 12/28/23.
//

import Foundation

@MainActor
class ImageGenerateViewModel: ObservableObject{
    
    @Published var textInput = ""
    @Published var canAnimateLoading = false
    @Published var btnAlreadyClicked : Bool

    init(textInput: String = "", canAnimateLoading: Bool = false, btnAlreadyClicked: Bool = false ) {
        self.textInput = textInput
        self.canAnimateLoading = canAnimateLoading
        self.btnAlreadyClicked = btnAlreadyClicked
    }
    
    
    func startLoadingAnimation(){
        //starts the loading animation on messages
        btnAlreadyClicked = true
        canAnimateLoading = true
    }

    func stopAnimation() async {
        //stops the loading animation on messages
        await delay(seconds: 2.0)
//        removeLoadingLastIndex()
        canAnimateLoading = false
        btnAlreadyClicked = false
    }
 
    func removeLoadingSign(loadingMsgId : UUID){
        PersistenceController.shared.editMsg(msgId: loadingMsgId, attribute: "isLoadingSign", newValue: false)
    }
    
    func generateImg(user: CDUser){

        if textInput.count < 15 {
            let msg = Message(text: "Please enter a longer prompt!", sentByUser: false, isError: true, imageData: nil)
            _ = PersistenceController.shared.addMsg(msg: msg, user: user)
            return
        }
        if btnAlreadyClicked{
            return
        }
        startLoadingAnimation()
        let textCopy = textInput
        // save the loading messages Id so that i can remove the loading sign
        let loadingMsgId = PersistenceController.shared.addMsg(
            msg: Message(text: textInput, sentByUser: true, isLoadingSign: true, imageData: nil),
            user: user)

        textInput = ""

        if user.numImgsGenerated_ <= ALLOWED_FREE_NUM_OF_GENERATED_IMGS{
            Task{ @MainActor in
                let res = await ImageServices.shared.generateImg(prompt: textCopy, token: user.accessToken)
                await stopAnimation()
                if res.err{
                    let msg = Message(text: res.msg ?? "Issue getting error messages, please try later.", sentByUser: false, isError: true, imageData: nil)
                   _ = PersistenceController.shared.addMsg(msg: msg, user: user)
                    removeLoadingSign(loadingMsgId: loadingMsgId)
                    return
                }
                removeLoadingSign(loadingMsgId: loadingMsgId)
                let downloadImgRes = await ImageServices.shared.downLoadImage(presignedUrl: res.data!.presignedUrl)
                if downloadImgRes == nil {
                    //                        TODO somethign went wrong let user know
                }
                let genImg = GeneratedImage(imgId: res.data!.imgId, prompt: res.data!.prompt, presignedUrl: res.data!.presignedUrl, data: downloadImgRes)
                // add image to to disk
                PersistenceController.shared.addImage(generatedImg: genImg, user: user)
                if res.data!.prompt.hasPrefix("REVISED###") {
                    //add the prompt only if it was revised by dall-e
                    _ = PersistenceController.shared.addMsg(msg: Message(text: res.data!.prompt, sentByUser: true, imageData: nil, isRevisedPrompt: true), user: user)
                }
                // add the image to the CDMessage coredata
                _ = PersistenceController.shared.addMsg(msg: Message(text: "", sentByUser: false, isImg: true, imageData: downloadImgRes), user: user)

                //add the next what would you like to generate msg for user
                _ = PersistenceController.shared.addMsg(msg: Message(text: generateQuestions.randomElement()!, sentByUser: false, imageData: nil), user: user)
                // update the user increment numImgsGenerated
                PersistenceController.shared.editUser(user: user, attribute: "numImgsGenerated_", newValue: user.numImgsGenerated_ + 1)
            }
        }else{
            removeLoadingSign(loadingMsgId: loadingMsgId)
            print("User has generated more than the free amount")
            _ = PersistenceController.shared.addMsg(msg: Message(text: "Sorry, you have exceeding the free limit for image generation.", sentByUser: false, isError: true, imageData: nil), user: user)
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
}
