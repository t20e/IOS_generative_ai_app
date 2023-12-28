//
//  GeneratedImagesView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI

struct GeneratedImagesView: View {
    

    private var randomPaddingHorizontal : [Int] = [15, 20, 10]
    private var randomPaddingVertical : [Int] = [5, 25, 10]
    private var randomImgWidth : [Int] = [75, 85, 95]
    private var randomImgHeight : [Int] = [85, 75, 95]

    var body: some View {
        VStack {
            Text("Generated images")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView{
                ForEach(0..<5) { _ in
                    HStack{
                        ForEach(0..<3) { _ in
                            Image(systemName: "rectangle.fill")
                                .resizable()
                                .frame(
                                    width: CGFloat(randomImgWidth.randomElement()!),
                                    height: CGFloat(randomImgHeight.randomElement()!)
                                )
                                .foregroundColor(.blue)
                                .padding(EdgeInsets(
                                    top: CGFloat(randomPaddingVertical.randomElement()!),
                                    leading: CGFloat(randomPaddingHorizontal.randomElement()!),
                                    bottom: CGFloat(randomPaddingVertical.randomElement()!),
                                    trailing: CGFloat(randomPaddingHorizontal.randomElement()!)))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GeneratedImagesView()
}
