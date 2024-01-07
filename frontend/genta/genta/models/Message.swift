////
////  Message.swift
////  genta
////
////  Created by Tony Avis on 1/7/24.
////
//
import Foundation
import SwiftUI
import SwiftData


@Model
class Message: Hashable, Identifiable {
    
    let id = UUID()
    let text: String
    let sentByUser: Bool
    let isError : Bool
    var isLoadingSign : Bool
    let isImg : Bool
    @Attribute(.externalStorage) let imageData: Data?
//    let imageData: Data?
    let isRevisedPrompt: Bool
    var canAnimateImg : Bool
    var textAlreadyAnimated : Bool
    let timestamp : Date
    
    init(
        text: String,
        sentByUser: Bool,
        isError: Bool = false,
        isLoadingSign: Bool = false,
        isImg: Bool = false,
        imageData: Data?,
        isRevisedPrompt: Bool = false,
        canAnimateImg: Bool = false,
        textAlreadyAnimated: Bool = false,
        timestamp: Date = Date.now
    ) {
        self.text = text
        self.sentByUser = sentByUser
        self.isError = isError
        self.isLoadingSign = isLoadingSign
        self.isImg = isImg
        self.imageData = imageData
        self.isRevisedPrompt = isRevisedPrompt
        self.canAnimateImg = canAnimateImg
        self.textAlreadyAnimated = textAlreadyAnimated
        self.timestamp = timestamp
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
//        this makes the ids conform to Hashable
    }
    
}
