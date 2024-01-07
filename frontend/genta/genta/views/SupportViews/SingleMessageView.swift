//
//  SingleChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI



struct SingleMessageView: View {
    let message : String
    let sentByUser : Bool
    let isError: Bool
    let isImg : Bool
    let imageData : Data?
    var isLoadingSign : Bool
    var isRevisedPrompt : Bool
    var canAnimateImg : Bool
    var textAlreadyAnimated : Bool
    
//    varaibles to animate a text letter by letter
    @State private var animatedText: String = ""
    @State private var currentIndex: String.Index?
    
    var body: some View {
        VStack{
            if isRevisedPrompt{
//                if the prompt was revised than just add the striaght line above it
                HStack{
                    if sentByUser {
                        Spacer()
                    }
                    
                    VStack(){
                        StraightLine()
                            .stroke(Color.theme.primColor, lineWidth: 0.5)
                            .frame(width: 50, height: 100)
                            .rotationEffect(Angle(degrees: 90))
                            .padding(.horizontal, 20)

                    }
                    if !sentByUser {
                        Spacer()
                    }
                    
                }
            }
            HStack(spacing : 75){
                if isImg {
                    HStack(alignment: .top){
                        Image(uiImage: UIImage(data: imageData!)!)
                            .resizable()
                            .frame(width:  225, height: 225)
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect( canAnimateImg ? 1 : 0.5)
                            .animation(.spring(response: 0.8, dampingFraction: 0.3, blendDuration: 0),value: canAnimateImg)

                        
                        RightTriangle()
                            .stroke(Color.theme.primColor, lineWidth: 0.5)
                            .frame(width: 50, height: 100)
                            .rotationEffect(Angle(degrees: 180.0))
                            .offset(x: 0, y: -60)
                            .padding(20)
                    }
                    .padding(20)
                }else{
                    if sentByUser {
                        Spacer()
                    }
                    
                    Text(filterMsg(prompt: animatedText))
                        .foregroundStyle(
                            sentByUser ?
                            Color.theme.textColor
                            : .white)
                        .padding(6)
                        .background(
                            sentByUser ? Color.clear :
                                isError ? Color.theme.errColor
                            : Color.theme.primColor
                        )
                        .font(.system(size: 14))
                        .foregroundColor(Color.theme.primColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .listRowSeparator(.hidden)
                        .overlay(alignment: sentByUser ? .bottomLeading : .bottomTrailing){
                            !sentByUser ?
                             animatedText == message ?
//                            only show the down arrow if the message has been completely animated
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 30, height: 20)
                                    .font(.title)
                                    .offset(x: sentByUser ? 5 : -5, y: 15)
                                    .foregroundColor(isError ? Color.theme.errColor : Color.theme.primColor)
                                : nil
                            : nil
                        }
                        .onAppear{
//                            MARK - text animation: if the messages wasnt sent by the user animate it letter by letter
                            if !sentByUser && !textAlreadyAnimated{
                                startTypewriterAnimation()
                            }else{
                                animatedText = message
                            }
                        }
                    if !sentByUser{
                        Spacer()
                    }
                }
            }
            .listRowSeparator(.hidden)
            if isLoadingSign{
                // show the loading sign this should also have a msg attach we should the msg than point a line down to show the loading sign
                HStack{
                    if sentByUser {
                        Spacer()
                    }
                    
                    VStack(){
                        StraightLine()
                            .stroke(Color.theme.primColor, lineWidth: 0.5)
                            .frame(width: 50, height: 100)
                            .rotationEffect(Angle(degrees: 90))
                            .padding(.horizontal, 20)

                        
                        LoadingIconView()
                            .offset(x: 0, y: -20)
                        
                    }
                    if !sentByUser {
                        Spacer()
                    }
                    
                }
            }
        }
    }
    
    func startTypewriterAnimation() {
        currentIndex = message.startIndex
        animatedText = ""

        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            guard let index = currentIndex else {
                timer.invalidate()
                return
            }

            animatedText.append(message[index])

            if index == message.index(before: message.endIndex) {
                timer.invalidate()
            } else {
                currentIndex = message.index(after: index)
            }
        }
    }
    
    
}


#Preview {
    SingleMessageView(message: "hello there are u the same user from before or a new user can can we sign you in", sentByUser: false, isError: true, isImg: true, imageData: UIImage(systemName: "arrowtriangle.down.fill")?.pngData(), isLoadingSign: false, isRevisedPrompt: false, canAnimateImg: false, textAlreadyAnimated: false
    )
}

