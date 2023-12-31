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
    
    @State var textInput = ""
    
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
                TextField("Prompt", text: $textInput)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.theme.primColor, lineWidth: 2)
                            .padding(4)
                    )
                //TODO turn button into loading sign
                Button(action: {
                    if textInput.count > 15 {
                        generateImg()
                    }else{
                        messages.append(Message(text: "Please enter a longer prompt!", sentByUser: false, isError: true))
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                .padding(.trailing, 15)
            }
        }
        .padding()
    }
    
    func generateImg(){
        Task{ @MainActor in
            let res = await user.imageServices.generateImgApiCAll(prompt: textInput, token: user.getAccessToken())
            if res.err{
                return messages.append(Message(text: res.msg, sentByUser: false, isError: true))
            }
            user.data.generatedImgs.append(GeneratedImgsStruct(imgId: res.data!.imgId, prompt: res.data!.prompt, presignedUrl: res.data!.presignedUrl))
            await user.addOneImage(idx: user.data.generatedImgs.count - 1)
            let newImg = user.data.generatedImgs[user.data.generatedImgs.count - 1]
            messages += [
                Message(text: newImg.prompt, sentByUser: true),
                Message(text: "", sentByUser: false, isImg: true, image: Image(uiImage: UIImage(data: newImg.data!)!)),
                Message(text: generateQuestions.randomElement()!, sentByUser: false)
            ]
            textInput = ""
        }
    }
    
    
}

#Preview {
    GenerateImgView()
}
