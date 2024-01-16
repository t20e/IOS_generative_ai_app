////
////  Message.swift
////  genta
////
////  Created by Tony Avis on 1/7/24.
////
//
import Foundation
import SwiftUI


//@Model
struct Message: Hashable, Identifiable {
    
    let id = UUID()
    let text: String
    let sentByUser: Bool
    let isError : Bool
    var isLoadingSign : Bool
    let isImg : Bool
//    @Attribute(.externalStorage) let imageData: Data?
    let imageData: Data?
    let isRevisedPrompt: Bool
    let timestamp : Date
    var alreadyAnimated : Bool
    init(
        text: String,
        sentByUser: Bool,
        isError: Bool = false,
        isLoadingSign: Bool = false,
        isImg: Bool = false,
        imageData: Data?,
        isRevisedPrompt: Bool = false,
        canAnimateImg: Bool = false,
        alreadyAnimated: Bool = false,
        timestamp: Date = Date.now
    ) {
        self.text = text
        self.sentByUser = sentByUser
        self.isError = isError
        self.isLoadingSign = isLoadingSign
        self.isImg = isImg
        self.imageData = imageData
        self.isRevisedPrompt = isRevisedPrompt
        self.alreadyAnimated = alreadyAnimated
        self.timestamp = timestamp
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
//        this makes the ids conform to Hashable
    }
    
}
