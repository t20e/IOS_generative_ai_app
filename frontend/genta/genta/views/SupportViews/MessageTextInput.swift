//
//  MessageTextInput.swift
//  genta
//
//  Created by Tony Avis on 1/4/24.
//

import SwiftUI
import SwiftData



struct MessageTextInput: View {
    
    @Binding var canAnimate : Bool
    @State var hideTextField = false
    @State var animateRotation = false
    @State var animateScale = false
    
    @Binding var textInput : String
    @State var action : () -> Void
    @Binding var placeHolder : String
    @Binding var btnAlreadyClicked : Bool
    var isExpandingTextField : Bool // this is to either make the textfield expand when the user types

    var body: some View {
        HStack(spacing: 25){
            if !hideTextField{
                TextField(placeHolder, text: $textInput, axis: isExpandingTextField ? .vertical : .horizontal)
                    .onChange(of: textInput) { _, newValue in
                        /* 
                            Since Im using the .vertical for textField it wont work like a regular .horizontal
                            Textifeld, so when the user clicks the return key it will go to next line instead of closing
                            keyboard this code stops that
                         */
                        guard let newValueLastChar = newValue.last else { return }
                        if newValueLastChar == "\n" {
                            textInput.removeLast()
                            dismissKeyboard()
                        }
                    }

                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.theme.actionColor, lineWidth: 1)
                    )
                    .autocapitalization(.none) //stops the auto capitilize of words
                    .autocorrectionDisabled()
                    .foregroundColor(Color.theme.textColor)
            }
            
            Image(systemName: canAnimate ? "circle.dotted" : "arrow.up.circle")
                .resizable()
                .scaleEffect(animateScale ? 2 : 1)
                .frame(width: 25, height: 25)
                .foregroundColor(Color.theme.actionColor)
                .rotationEffect(.degrees( animateRotation ? -90 : 0) )
            
                .onTapGesture {
                    if !btnAlreadyClicked{
                        action()
                    }
                    if canAnimate{
                        animateRotation = true
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.3, blendDuration: 0)){
                            hideTextField = true
                        }
                        withAnimation(.easeInOut(duration: 0.5)){
                            animateScale = true
                        }
                        //                        TODO not working
                        //                        withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                        //                            animateRotation = true
                        //                        }
                    }
                }
                .onChange(of: canAnimate){
                    print("CanAnimated changed", canAnimate)
                    withAnimation(.default){
                        //stop all animations
                        if !canAnimate{
                            animateScale = false
                            animateRotation = false
                            animateScale = false
                            hideTextField = false
                        }
                    }
                }
                .padding(.trailing, canAnimate ? 0 : 15)
        }
    }
    
    
}

#Preview {
    func exampleFunction() {
        print("Action triggered!")
    }
//    let messages : [Message] = []
    return MessageTextInput(
        canAnimate: .constant(
            false
        ),
        textInput: .constant(
            ""
        ),
        action: exampleFunction,
//        messages: .constant(messages),
        placeHolder: .constant(""),
        btnAlreadyClicked: .constant(false),
        isExpandingTextField: false
    )
    
}
