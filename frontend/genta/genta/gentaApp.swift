//
//  gentaApp.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

@main
struct gentaApp: App {
    @StateObject var user = User()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(user)
        }
    }
}
