//
//  PersistenceController.swift
//  Genta
//
//  Created by Tony Avis on 1/10/24.
//

import Foundation
import CoreData
import UIKit

class PersistenceController: ObservableObject{
    let container = NSPersistentContainer(name: "Genta")
    static let shared = PersistenceController()

    init(){
        container.loadPersistentStores{ desc, error in
            if let error = error{
                fatalError("Failed to load persistent stores \(error.localizedDescription)")
            }
        }
    }
    
    func save(){
        do{
            try self.container.viewContext.save()
            print("Data saved")
        }catch{
            print("ERROR: Data not saved \(error)")
        }
    }
    
    func addUser(userStruct : User){
        //TODO remove all from database
//        deleteAll()
        let user = CDUser(context : self.container.viewContext)
        user.id_ = userStruct.id
        user.age_ = userStruct.age
        user.email_ = userStruct.lastName
        user.firstName_  = userStruct.firstName
        user.lastName_ = userStruct.lastName
        user.accessToken_ = userStruct.accessToken
        user.numImgsGenerated_ = userStruct.numImgsGenerated
        user.isCurrUser_ = true
        save()
    }
    
    func editUser(user : CDUser){
        //pass in the user form parameters
        // lets say that we want to update the firstName we pass it in then
        // user.firstName = firstName
        user.firstName_ = "jack"
        save()
    }
    
    func deleteAll(){
        //delete all data
        // TODO make the CDMEssages and CDIMgaes to cascade so that when user is deleted they are also deleted
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try self.container.viewContext.execute(deleteRequest)
            self.container.viewContext.reset()
            save()
        }
        catch{
            print ("There was an error")
        }
    }

}
