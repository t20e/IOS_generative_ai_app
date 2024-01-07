//
//  gentaApp.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI
import SwiftData


// GLOBAL VARIABLES
let isDeployed = false
let baseURL: String = {
    return isDeployed ? "https://PAIENDPOINT" : "http://localhost:8080"
}()
let ALLOWED_FREE_NUM_OF_GENERATED_IMGS = 15


@main
struct gentaApp: App {
    
//    @Environment(\.modelContext) private var context

    
    var body: some Scene {
        WindowGroup {
            MainView()
//                .environmentObject(user)
            //                .onAppear(perform: self.checkUserToken)
        }
        .modelContainer(for: User.self)
        //        .modelContainer(for: Message.self)
    }
    
//    
//    func checkUserToken(){
//        Task{ @MainActor in
//            await user.checkToken()
//        }
//    }
//    
}


