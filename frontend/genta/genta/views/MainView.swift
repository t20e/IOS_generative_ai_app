//
//  ContentView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        if true{
            //            user is logged in
            VStack{
                                HeaderIntro()
                                IntroView()
                    }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.backgroundColor)
        }
    }
}

#Preview {
    MainView()
}
