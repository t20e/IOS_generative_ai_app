//
//  ContentView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct MainView: View {
    var mainCon = MainViewController()
    
    var body: some View {
        if true{
            //            user is not logged in
//            VStack{
                HeaderIntro()
                OnBoardingView()
//                    }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.theme.backgroundColor)
        }else{
//            user is logged in
        }
    }
}

#Preview {
    MainView()
}
