//
//  EmptyImagesView.swift
//  genta
//
//  Created by Tony Avis on 12/28/23.
//

import SwiftUI

struct EmptyImagesView: View {
    
    private var randomPaddingHorizontal : [Int] = [15, 20, 10]
    private var randomPaddingVertical : [Int] = [5, 25, 10]
    private var randomImgWidth : [Int] = [75, 85, 95]
    private var randomImgHeight : [Int] = [85, 75, 95]

    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(Color.theme.primColor, lineWidth: 1)
            .frame(
                width: CGFloat(randomImgWidth.randomElement()!),
                height: CGFloat(randomImgHeight.randomElement()!)
            )
            .padding(EdgeInsets(
                top: CGFloat(randomPaddingVertical.randomElement()!),
                leading: CGFloat(randomPaddingHorizontal.randomElement()!),
                bottom: CGFloat(randomPaddingVertical.randomElement()!),
                trailing: CGFloat(randomPaddingHorizontal.randomElement()!)))
    }
}

#Preview {
    EmptyImagesView()
}
