//
//  utils.swift
//  genta
//
//  Created by Tony Avis on 12/20/23.
//

import Foundation


func validateNames(text: String) ->  (err:Bool, msg:String) {
    let regexPattern = "^[^0-9]+$"
    do {
        let regex = try NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        let numberOfMatches = regex.numberOfMatches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        if numberOfMatches > 0{
            return (false, "")
        }else{
            return (true, "No numbers are allowed in names")
        }
    }catch{
        return (true,  "Something went wrong, please check your name")
    }
}
