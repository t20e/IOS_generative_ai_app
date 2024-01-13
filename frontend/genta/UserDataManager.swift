//
//  UserDataManager.swift
//  Genta
//
//  Created by Tony Avis on 1/10/24.
//

import Foundation
import CoreData

class UserDataManager: ObservableObject {
    @Published var user: CDUser?
    @Published var isLoggedIn : Bool = false
    
    init() {
        getCurrentLoggedInUser()
    }
    
    func getCurrentLoggedInUser() {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCurrUser == %@", NSNumber(value: true))

        do {
            let users = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            user = users.first
            isLoggedIn = true
        } catch {
            print("Error fetching current logged-in user: \(error.localizedDescription)")
            user = nil
            isLoggedIn = false
        }
    }
}
