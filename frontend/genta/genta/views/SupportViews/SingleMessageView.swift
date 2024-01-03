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
    let image : Image
    var isLoadingSign : Bool
    var isRevisedPrompt : Bool
    
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
                        image
                            .resizable()
                            .frame(width:  225, height: 225)
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                        
                        
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
                    
                    Text(filterMsg(prompt: message))
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
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .font(.title)
                                .offset(x: sentByUser ? 5 : -5, y: 15)
                                .foregroundColor(isError ? Color.theme.errColor : Color.theme.primColor)
                            : nil
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
    
    
}


#Preview {
    SingleMessageView(message: "hello there are u the same user from before or a new user can can we sign you in", sentByUser: false, isError: true, isImg: true, image: Image(systemName: "arrowtriangle.down.fill"), isLoadingSign: false, isRevisedPrompt: false)
}

