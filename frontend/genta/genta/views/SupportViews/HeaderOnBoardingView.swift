//
//  HeaderIntro.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct HeaderOnBoardingView: View {
    var body: some View {
            VStack{
                //                MARK - add the apps image here
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("App Name")
                    .font(.title)
                    .bold()
                Text("powered by dall-e")
                    .opacity(0.5)
                    .padding(.leading, 150)
            }
    }
}

#Preview {
    HeaderOnBoardingView()
}
