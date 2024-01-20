//
//  DashboardView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI


struct DashboardView: View {
   
    let user : CDUser
    init(user: CDUser) {
        self.user = user
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.actionColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        UIPageControl.appearance().tintColor = UIColor.lightGray
    }
 
    var body: some View {
        TabView {
            AllGeneratedImgsView(user : user)
                .background(Color.theme.baseColor)
            GenerateImgView(user: user)
                .background(Color.theme.baseColor)
            SettingsView(user: user)
                .background(Color.theme.baseColor)
        }
        .edgesIgnoringSafeArea(.all)
        .padding(.bottom, 20)
        .frame(
            width: UIScreen.main.bounds.width ,
            height: UIScreen.main.bounds.height
        )
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
    }
}

//#Preview {
//    DashboardView()
//}
