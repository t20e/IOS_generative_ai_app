//
//  PersistenceController.swift
//  Genta
//
//  Created by Tony Avis on 1/10/24.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

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
    
    func save(purpose : String){
        print("Saving data for \(purpose)")
        do{
            try self.container.viewContext.save()
            print("Data saved")
        }catch{
            print("ERROR: Data not saved \(error)")
        }
    }


    
    func addUser(userStruct : User) async{
//        deleteAll() // remove all from database
        let user = CDUser(context : self.container.viewContext)
        user.id_ = userStruct.id
        user.age_ = userStruct.age
        user.email_ = userStruct.email
        user.firstName_  = userStruct.firstName
        user.lastName_ = userStruct.lastName
        user.accessToken_ = userStruct.accessToken
        user.numImgsGenerated_ = userStruct.numImgsGenerated
        user.isCurrUser_ = true
        
        if userStruct.numImgsGenerated > 0{
            // add the user images to coreData if they have images
            for image in userStruct.generatedImgs {
                let imgData = await ImageServices.shared.downLoadImage(presignedUrl: image.presignedUrl)
                let newCDImg = CDGeneratedImage(context: self.container.viewContext)
                newCDImg.prompt = image.prompt
                newCDImg.data_ = imgData
                newCDImg.presignedUrl = image.presignedUrl
                newCDImg.imgId = image.imgId
                user.addToGeneratedImages_(newCDImg)
            }
        }
        save(purpose: "Adding user")
    }
    
    func editUser(user : CDUser, attribute: String, newValue: Any){
        // - Parameters
        //  attribute in the user to update, it has to be the setter option and not the getter option
        user.setValue(newValue, forKey: attribute)
        save(purpose: "Updating user, for attribute: \(attribute)")
    }
    
    func deleteAllMsg(){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDMessage")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try self.container.viewContext.execute(deleteRequest)
            save(purpose: "Deleting all messages")
        }
        catch{
            print("error deleting messages, error: \(error)")
        }
    }
    
    func deleteAll(user : CDUser){
        print("Attempting to delete all")
        user.isCurrUser_ = false // this needed to done for the UI to show login/reg view
        save(purpose: "Updaign the user to set isCurrUser_ to false before Deleting All Data")
        let entityNames = ["CDUser", "CDGeneratedImage", "CDMessage"]
        
        for entityName in entityNames {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.container.viewContext.execute(deleteRequest)
                save(purpose: "Deleting All Data")
            } catch let error as NSError {
                // Handle the error
                print("Error deleting entity \(entityName): \(error), \(error.userInfo)")
            }
        }
    }
    
    func addImage(generatedImg: GeneratedImage, user: CDUser){
        //add image to user persistance
        let image = CDGeneratedImage(context: self.container.viewContext)
        image.imgId = generatedImg.imgId
        image.presignedUrl = generatedImg.presignedUrl
        image.prompt = generatedImg.prompt
        image.cduser = user
        image.data_ = generatedImg.data
        save(purpose: "Adding an image")
    }
    
    
    func addMsg(msg : Message, user : CDUser) -> UUID{
        let CDMsg = CDMessage(context: self.container.viewContext)
        CDMsg.id = UUID()
        CDMsg.text_ = msg.text
        CDMsg.sentByUser = msg.sentByUser
        CDMsg.isError = msg.isError
        CDMsg.isLoadingSign = msg.isLoadingSign
        CDMsg.isImg = msg.isImg
        CDMsg.imageData_ = msg.imageData
        CDMsg.isRevisedPrompt = msg.isRevisedPrompt
        CDMsg.alreadyAnimated = msg.alreadyAnimated
        CDMsg.cduser = user
        save(purpose: "Adding a message")
        return CDMsg.id
    }
    
    func createMessagesInMemory(msg : Message) -> CDMessage{
        // theses messages wont be saved to disk they will only be used in the OnBoardingView can make messages array
        let CDMsg = CDMessage(context: self.container.viewContext)
        CDMsg.id = UUID()
        CDMsg.text_ = msg.text
        CDMsg.sentByUser = msg.sentByUser
        CDMsg.isError = msg.isError
        CDMsg.isLoadingSign = msg.isLoadingSign
        CDMsg.isImg = msg.isImg
        CDMsg.imageData_ = msg.imageData
        CDMsg.isRevisedPrompt = msg.isRevisedPrompt
        CDMsg.alreadyAnimated = msg.alreadyAnimated
        return CDMsg
    }
    
    func editMsg(msgId : UUID, attribute: String, newValue: Any){
        
        let fetchRequest: NSFetchRequest<CDMessage> = CDMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", msgId as CVarArg)

        do {
            let messages = try self.container.viewContext.fetch(fetchRequest)
            if let messageToUpdate = messages.first {
                messageToUpdate.setValue(newValue, forKey: attribute)
                save(purpose: "Updating a msg")
            } else {
                print("Message with specified ID not found")
            }
        } catch {
            print("Error fetching message: \(error)")
        }
    }
    
}
