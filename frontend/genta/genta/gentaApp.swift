//
//  gentaApp.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

import SwiftData

let isDeployed = false

let baseURL: String = {
    return isDeployed ? "https://PAIENDPOINT" : "http://localhost:8080"
}()

let ALLOWED_FREE_NUM_OF_GENERATED_IMGS = 15


@main
struct gentaApp: App {
    
    @StateObject var user : User = User()
   
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(user)
                .onAppear(perform: self.checkUserToken)
        }
    }
    
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
    func checkUserToken(){
        Task{ @MainActor in
            await user.checkToken()
        }
    }
    
}
