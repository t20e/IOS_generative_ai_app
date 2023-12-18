//
//  Color.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    let accentColor = Color("accentColor")
    let backgroundColor = Color("backgroundColor")
    let primColor = Color("primColor") //i coulnt call it primaryColor because of some conflict. The "PrimaryColor" color asset name resolves to a conflicting Color symbol "primary". Try renaming the asset.
    let secColor = Color("secColor") //same here
    let tertiaryColor = Color("tertiaryColor")
}
