//
//  ContentView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: CDUser.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isCurrUser_ == %@", NSNumber(value: true)),
        animation: .default)
    private var users: FetchedResults<CDUser>
 
    var body: some View {

        VStack{
            if let user = users.first {
                DashboardView(user: user)
            }else{
                // user is not signed in
                HeaderOnBoardingView()
                OnBoardingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.baseColor) 
//        .onAppear{
//            PersistenceController.shared.deleteAllMsg()
//        }
    }
}


#Preview {
    MainView()
}
