//
//  DashboardView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct DashboardView: View {
    let colors : [Color] = [.red, .blue, .purple]
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .blue
        UIPageControl.appearance().pageIndicatorTintColor = .red
        UIPageControl.appearance().tintColor = .red
    }
    
    var body: some View {
        ScrollView {
            TabView {
                GeneratedImagesView()
                    .background(colors[0])
                GenerateView()
                    .background(colors[1])
                SettingsView()
                    .background(colors[2])
            }
            .frame(
                width: UIScreen.main.bounds.width ,
                height: UIScreen.main.bounds.height
            )
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    DashboardView()
}
