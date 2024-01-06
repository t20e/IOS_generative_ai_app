//
//  LoadingIconView.swift
//  genta
//
//  Created by Tony Avis on 1/3/24.
//

import SwiftUI

struct LoadingIconView: View {
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange, .pink, .cyan]
       let duration: Double = 1.5
       
       @State private var rotation: Double = 0

       var body: some View {
           ZStack {
               ForEach(colors.indices, id: \.self) { index in
                   RoundedRectangle(cornerRadius: 50)
                       .fill(colors[index])
//                       .frame(width: 2, height: 20)
                       .frame(width: 5, height: 30)
                       .rotationEffect(.degrees(Double(index) * (360 / Double(colors.count))))
               }
           }
           .rotationEffect(.degrees(rotation))
           .onAppear {
               withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                   rotation = 360
               }
           }
       }
}

#Preview {
    LoadingIconView()
}
