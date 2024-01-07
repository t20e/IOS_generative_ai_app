//
//  ContentView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import SwiftData


struct MainView: View {
    var mainCon = MainViewController()
    @Environment(\.modelContext) private var context
    @Query private var users: [User]

    var body: some View {
        
        VStack{
            if users.count == 0{
                //user is not signed in
                HeaderOnBoardingView()
                OnBoardingView()
            }else{
                DashboardView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.baseColor)
        .onAppear{
//            PersistenceManager.shared.deleteAll(context: context)
        }
    }
    
}


#Preview {
    MainView()
}
