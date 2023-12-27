//
//  ContentView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var user : User
    var mainCon = MainViewController()
    
    
    var body: some View {
        if user.isSingedIn{
            Text("user is signed in, user name: \(user.user.firstName)")
            
            Text("dashboard")
        }else{
            VStack{
                HeaderIntro()
                OnBoardingView()
                    }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.theme.backgroundColor)
        }
    }
}

#Preview {
    MainView()
}
