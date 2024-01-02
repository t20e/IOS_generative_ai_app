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
            //        if !true{
            DashboardView()
        }else{
            VStack{
                HeaderOnBoardingView()
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
