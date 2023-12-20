//
//  MainViewController.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation

class MainViewController: ObservableObject{
    @Published var messages: [Message] = []
    
    init(){}
    
}
