//
//  Image.swift
//  genta
//
//  Created by Tony Avis on 1/9/24.
//

import Foundation
import SwiftData


class ImageData{
    var prompt: String
    var data : Data? // store image as string of base64 i coulnt just leave it a uiImage becuase uiimage doesnt conform to codable
    let timestamp : Date

    
    init(
        prompt: String,
        data: Data? = nil,
        timestamp: Date = Date.now
    ) {
        self.prompt = prompt
        self.data = data
        self.timestamp = timestamp
    }
}
