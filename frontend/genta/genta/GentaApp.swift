//
//  gentaApp.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import CoreData

// GLOBAL VARIABLES
let isDeployed = true
let baseURL : String = {
    return isDeployed ? "https://www.genta-ios.app" : "http://localhost:8080"
}()
let ALLOWED_FREE_NUM_OF_GENERATED_IMGS = 15


@main
struct gentaApp: App {
    private var persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(PersistenceController.shared)
        }
    }

}


