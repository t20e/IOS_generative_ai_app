//
//  MsgsUtils.swift
//  genta
//
//  Created by Tony Avis on 12/31/23.
//

import Foundation
func filterMsg(prompt : String) -> String{
    if prompt.hasPrefix("REVISED###") {
        return "Revised Prompt: \(String(prompt.dropFirst(10)))"
    }
    return "\(prompt)"
}
