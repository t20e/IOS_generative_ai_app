//
//  TokenFoundView.swift
//  genta
//
//  Created by Tony Avis on 1/4/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.7
    @State private var screenWidth = UIScreen.main.bounds.width / 1.3
    @State private var gradientOffset: CGFloat = 0
    
    @Binding var purpose : String
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.actionColor, Color.theme.primColor]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .scaleEffect(scale)
            .mask(
                Text(purpose)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 1.5).repeatForever(), value: scale)
                    .onAppear {
                        withAnimation {
                            scale = 1.2
                        }
                    }
            )
            
            Image(systemName: "circle.dotted")
                .resizable()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme.primColor, Color.theme.actionColor]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    .mask(Image(systemName: "circle.dotted")
                        .resizable()
                        .frame(width: screenWidth,height:  screenWidth)
                          
                    )
                    .offset(x: gradientOffset)
                    .animation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false), value: gradientOffset
                    )
                )
                .frame(width: screenWidth,height:  screenWidth)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotation += 360
                    }
                }
        }
    }
}

#Preview {LoadingView(purpose: .constant("Almost There"))}
