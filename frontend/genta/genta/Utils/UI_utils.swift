//
//  UI_utils.swift
//  genta
//
//  Created by Tony Avis on 1/1/24.
//

import Foundation
import SwiftUI

struct ContentShape<Content>: View where Content: View {
//    used for when u want an action to happen like hitten a text but u want the parent of the text to also call the action not just the text
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content.contentShape(Rectangle())
    }
}

struct StraightLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the endpoints of the straight line
        let startPoint = CGPoint(x: rect.minX, y: rect.midY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.midY)

        // Move to the starting point
        path.move(to: startPoint)

        // Draw the straight line
        path.addLine(to: endPoint)

        return path
    }
}


struct RightTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the vertices of the right triangle
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let rightAnglePoint = CGPoint(x: rect.minX, y: rect.minY)

        // Move to the starting point
        path.move(to: startPoint)

        // Draw the two sides of the right triangle
        path.addLine(to: rightAnglePoint)
        path.addLine(to: endPoint)

        return path
    }
}
