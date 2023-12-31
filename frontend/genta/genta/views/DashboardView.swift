//
//  DashboardView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct DashboardView: View {
    let colors : [Color] = [.red, .pink, .purple]
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .blue
        UIPageControl.appearance().pageIndicatorTintColor = .red
        UIPageControl.appearance().tintColor = .red
    }
    
    var body: some View {
            TabView {
                AllGeneratedImgsView()
                    .background(colors[0])
                GenerateImgView()
                    .background(colors[1])
                SettingsView()
                    .background(colors[2])
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

#Preview {
    DashboardView()
}
