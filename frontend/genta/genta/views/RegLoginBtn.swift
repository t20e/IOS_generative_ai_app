//
//  RegLoginBtn.swift
//  genta
//
//  Created by Tony Avis on 12/18/23.
//

import SwiftUI

struct RegLoginBtn: View {
    let title: String
    let background: Color
    let textColor: Color
    let action: () -> Void
    
    var body: some View {
        Button{
            //                    attempt login or register
            
            action()
            
        }label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                    .cornerRadius(100)
                Text(title)
                    .foregroundStyle(textColor)
                    .bold()
            }
        }
    }
}

#Preview {
    RegLoginBtn(title: "value", background : Color.theme.backgroundColor, textColor: Color.white,  action: {
        
    })
}
