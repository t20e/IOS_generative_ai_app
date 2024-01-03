//
//  GenerateView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct GenerateImgView: View {
    
    @EnvironmentObject var user : User
    @ObservedObject var viewCont = ImageGenerateViewController()
    
    @State var messages : [Message] = [
        Message(text: "What would you like to generate?", sentByUser: false)
    ]
    
    @State var isGenerating = false
    @State var textInput = ""
    @State var canAnimateRotation = false
    @State var showTextField = true

    let generateQuestions : [String] = [
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
            ChatView(messages: messages)
            
            HStack(spacing: 25){
                if showTextField{
                    TextField("Prompt", text: $textInput)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.theme.actionColor, lineWidth: 1)
                        )
                        .autocapitalization(.none) //stops the auto capitilize of words
                        .autocorrectionDisabled()
                        .foregroundColor(Color.theme.textColor)
                }else{
                    Spacer()
                }
                
                Image(systemName: isGenerating ? "circle.dotted" : "arrow.up.circle")
                
                    .resizable()
                    .scaleEffect(isGenerating ? 2 : 1)
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.theme.actionColor)
                
                    .rotationEffect(canAnimateRotation ? .degrees(-90) : .degrees(0))


                    .onTapGesture {
                        
                        if !isGenerating && !canAnimateRotation{
                            if textInput.count > 15 {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.3, blendDuration: 0)){
                                    isGenerating.toggle()
                                }
                                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                                    canAnimateRotation.toggle()
                                }
                                showTextField.toggle()
                                generateImg()
                            }else{
                                messages.append(Message(text: "Please enter a longer prompt!", sentByUser: false, isError: true))
                            }
                        }
                    }
                
                
                    .padding(.trailing, isGenerating ? 0 : 15)
                if isGenerating{
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    func generateImg(){
        let textCopy = textInput
        
        messages.append(Message(text: textInput, sentByUser: true, isLoadingSign: true))
        textInput = ""
        return Void() //TODO remove
        
        
        if user.data.numOfImgsGenerated <= ALLOWED_FREE_NUM_OF_GENERATED_IMGS{
            Task{ @MainActor in
                let res = await user.imageServices.generateImgApiCAll(prompt: textCopy, token: user.getAccessToken())
                isGenerating = false
                showTextField = true
                canAnimateRotation = false

                if let lastIndex = messages.indices.last {
                    // Update the last item
                    messages[lastIndex].isLoadingSign = false
                }
                
                
                if res.err{
                    return messages.append(Message(text: res.msg ?? "Issue getting error messages, please try later.", sentByUser: false, isError: true))
                }
                user.data.generatedImgs.append(GeneratedImgsStruct(imgId: res.data!.imgId, prompt: res.data!.prompt, presignedUrl: res.data!.presignedUrl))
                await user.addOneImage(idx: user.data.generatedImgs.count - 1)
                let newImg = user.data.generatedImgs[user.data.generatedImgs.count - 1]
                
                //       if it wasnt revised than don't append to messages
                if newImg.prompt.hasPrefix("REVISED###") {
                    messages.append(Message(text: newImg.prompt, sentByUser: true, isRevisedPrompt:true))
                }
                messages += [
                    Message(text: "", sentByUser: false, isImg: true, image: Image(uiImage: UIImage(data: newImg.data!)!)),
                    Message(text: generateQuestions.randomElement()!, sentByUser: false)
                ]
                user.data.numOfImgsGenerated += 1
            }
        }else{
            print("User has generated more than the free amount")
            return messages.append(Message(text: "Sorry, you have exceeding the free limit for image generation.", sentByUser: false, isError: true))
        }
    }
    
    
}

#Preview {
    GenerateImgView()
}
