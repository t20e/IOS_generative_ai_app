//
//  KeyboardResponsiveModifier.swift
//  Genta
//
//  Created by Tony Avis on 1/23/24.
//
import SwiftUI
//import Combine


struct KeyboardResponsiveModifier: ViewModifier {
    
    /*
        IMPORTANT: I had an issue using the .tabViewStyle(.page) on TabView; issue was when I clicked on the
        TextField in the TabView the keyboard would block the TextField, this struct help solve that issue, by
        moving the view up so that when the keyboard appears and it doesn't block the textField
     */
    
    @State private var textFieldPosition: CGFloat = 0
    @State private var textFieldHeight: CGFloat = 0
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            textFieldPosition = proxy.frame(in: .global).minY
                            textFieldHeight = proxy.size.height
                        }
                }
            )
            .onAppear(perform: subscribeToKeyboardEvents)
    }
    
    private func calculateOffset(with keyboardHeight: CGFloat, screenHeight: CGFloat) -> CGFloat {
        let adjustedPosition = screenHeight - textFieldPosition - textFieldHeight
        let newOffset =  keyboardHeight - adjustedPosition
        return newOffset
    }
    
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            let screenHeight = UIScreen.main.bounds.height
            let keyboardHeight = keyboardFrame.height
//            withAnimation(.linear(duration: 0.05)) {
            // when the keyboard popups up moves the view up so that the TextField is visible above the keyboard
            offset = calculateOffset(with: keyboardHeight, screenHeight: screenHeight)
//            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//            withAnimation(.linear(duration: 0.05)) {
                offset = 0 // when the keyboard disappears it moves the view back down
//            }
        }
    }
}

extension View {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsiveModifier())
    }
    
    func dismissKeyboard(){ // close the keyboard when the return key is press this is not needed for a
        // TextField that is horizontal but is needed if its a veritcal TextField
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
