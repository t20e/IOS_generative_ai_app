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
            /*
                IMPORTANT: in views that observed for CDUser changes I could not pass the user as object from parent to child,
                I had to query the user again like in Dashboard etc...
            */
            if users.first != nil {
//                DashboardView(user: user)
                DashboardView()
            }else{
                // user is not signed in
                HeaderOnBoardingView()
                OnBoardingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.baseColor)
    }
}


#Preview {
    MainView()
}
