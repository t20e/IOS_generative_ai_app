//
//  gentaApp.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


let isDeployed = false
let baseURL: String = {
    return isDeployed ? "https://PAIENDPOINT" : "http://localhost:8080"
}()

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
