//
//  UI_utils.swift
//  genta
//
//  Created by Tony Avis on 1/1/24.
//

import Foundation
import SwiftUI

struct ContentShape<Content>: View where Content: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content.contentShape(Rectangle())
    }
}
