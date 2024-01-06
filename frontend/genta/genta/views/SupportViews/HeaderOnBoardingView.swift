//
//  HeaderIntro.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct HeaderOnBoardingView: View {
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
            VStack{
                //                MARK - add the apps image here
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .frame(width: 64,height: 64)
                    .cornerRadius(30)
                Text("genTa")
                    .font(.title)
                    .bold()
                Text("powered by dall-e")
                    .opacity(0.5)
                    .foregroundColor(.gray)
                    .padding(.leading, 150)
            }
    }
}

#Preview {
    HeaderOnBoardingView()
}
