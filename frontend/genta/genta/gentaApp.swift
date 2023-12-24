//
//  gentaApp.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

@main
struct gentaApp: App {
    //    @EnvironmentObject can be accessed anywhere in the code
//    @EnvironmentObject var userServices : UserServices
    
    var body: some Scene {
        WindowGroup {
            MainView()
//                .environmentObject(userServices)
        }
    }
}
