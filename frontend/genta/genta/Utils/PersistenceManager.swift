
import Foundation
import SwiftData

final class PersistenceManager{
    /*
     Singleton class to pass around app to CRUD from swiftData, I could not create a self variable to store
     the context, I needed to pass it into each function from a view that had the context in it!
     */
    
    static let shared = PersistenceManager()
    //    var context : ModelContext? = nil
    
    private init(){}
    
    
    func saveUser(user : User, context : ModelContext){
        /// - Parameters
        ///    - user object
        print("Saving user to swiftData")
        //save to context swiftData
        context.insert(user)
    }
    
    func addMessage(message : Message, context : ModelContext){
        
    }
    
    func deleteAll(context : ModelContext){
        do {
            try context.delete(model: User.self)
        } catch {
            print("Failed to clear all Country and City data.")
        }
    }
    
}
