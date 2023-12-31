//
//  SingleChatView.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI


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

struct SingleMessageView: View {
    let message : String
    let sentByUser : Bool
    let isError: Bool
    let isImg : Bool
    let image : Image
    let isLoadingSign : Bool
    
 
    
    var body: some View {
        HStack(spacing : 75){
            if isImg {
                HStack(alignment: .top){
                    image
                        .resizable()
                        .frame(width:  225, height: 225)
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                    
                    
                    RightTriangle()
                        .stroke(Color.red, lineWidth: 0.5)
                        .frame(width: 50, height: 100)
                        .rotationEffect(Angle(degrees: 180.0))
                        .offset(x: 0, y: -60)
                        .padding(20)
                }
                .padding(20)
            }else{
                if sentByUser {
                    Spacer()
                }
                Text(filterMsg())
                    .padding(6)
                    .background(
                        sentByUser ? Color.blue.opacity(0.0) :
                            isError ? .red : .blue
                    )
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .listRowSeparator(.hidden)
                    .overlay(alignment: sentByUser ? .bottomLeading : .bottomTrailing){
                        !sentByUser ?
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .font(.title)
                                .offset(x: sentByUser ? 5 : -5, y: 15)
                                .foregroundColor(isError ? .red : .blue)
                        : nil
                    }

                
                if !sentByUser{
                    Spacer()
                }
            }
        }
        .listRowSeparator(.hidden)
    }
    
    func filterMsg() -> String{
        if message.hasPrefix("REVISED###") {
            return "Revised Prompt: \(String(message.dropFirst(10)))"

        }
            return "\(message)"
    }
    
}


#Preview {
    SingleMessageView(message: "hello there are u the same user from before or a new user can can we sign you in", sentByUser: false, isError: false, isImg: true, image: Image(systemName: "arrowtriangle.down.fill"), isLoadingSign: false)
}

