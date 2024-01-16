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
    
    func save(){
        do{
            try self.container.viewContext.save()
            print("Data saved")
        }catch{
            print("ERROR: Data not saved \(error)")
        }
    }
    
    func addUser(userStruct : User) async{
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
        save()
    }
    
    func editUser(user : CDUser){
        //pass in the user form parameters
        // lets say that we want to update the firstName we pass it in then
        // user.firstName = firstName
        //        user.firstName_ = "jack"
        //        save()
    }
    
    func deleteAll(user : CDUser){
        print("Attempting to delete all")
        user.isCurrUser_ = false
        save()
        let entityNames = ["CDUser", "CDGeneratedImage", "CDMessage"]
        
        for entityName in entityNames {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try self.container.viewContext.execute(deleteRequest)
                save()
            } catch let error as NSError {
                // Handle the error
                print("Error deleting entity \(entityName): \(error), \(error.userInfo)")
            }
        }
    }
    
    func addMsg(msg : Message, user : CDUser){
        let CDMsg = CDMessage(context: self.container.viewContext)
        CDMsg.id = UUID()
        CDMsg.text_ = msg.text
        CDMsg.sentByUser = msg.sentByUser
        CDMsg.isError = msg.isError
        CDMsg.isLoadingSign = msg.isLoadingSign
        CDMsg.isImg = msg.isImg
        CDMsg.imageData_ = msg.imageData
        CDMsg.isRevisedPrompt = msg.isRevisedPrompt
//        CDMsg.canAnimateImg = msg.canAnimateImg
        CDMsg.alreadyAnimated = msg.alreadyAnimated
//        CDMsg.timestamp = msg.timestamp
        save()
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
//        CDMsg.canAnimateImg = msg.canAnimateImg
        CDMsg.alreadyAnimated = msg.alreadyAnimated
//        CDMsg.timestamp = msg.timestamp
        return CDMsg
    }
    
}
