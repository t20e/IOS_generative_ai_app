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
                DashboardView()
            }else{
                // user is not signed in
                HeaderOnBoardingView()
                OnBoardingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.baseColor)
        .onAppear{
//            if let user = users.first{
//                // PersistenceController.shared.editUser(user: user)
//            }
//            PersistenceController.shared.deleteAll()
        }
    }
 
//    func checkToken(){
//        KeyChainManager.shared.search()
//    }
 
}


#Preview {
    MainView()
}
