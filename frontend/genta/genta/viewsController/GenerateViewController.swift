//
//  GenerateViewController.swift
//  genta
//
//  Created by Tony Avis on 12/28/23.
//

import Foundation

class GenerateViewController: ObservableObject{
    @Published var messages : [Message] = [
        Message(text: "What would you like to generate?", sentByUser: false)
    ]
}
