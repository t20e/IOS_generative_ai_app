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
    let primColor = Color("primColor")
    let baseColor = Color("baseColor")
    let actionColor = Color("actionColor")
    let textColor = Color("textColor")
    let errColor = Color("errColor")
    
//    colors for the swipe backgrounds
    let backgrondColorOne = Color("backgrondColorOne")
    let backgrondColorTwo = Color("backgrondColorTwo")
    let backgrondColorThree = Color("backgrondColorThree")
}
