//
//  EditPreferencesView.swift
//  genta
//
//  Created by Tony Avis on 12/30/23.
//

import SwiftUI

struct EditPreferencesView: View {
//    @EnvironmentObject var user : User

    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Help & Support")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding()
            VStack{
                HStack(spacing: 50){
                    VStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 50, height: 50)
                            Text("Light Mode")
                            .font(.footnote)
                    }
                    VStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 50, height: 50)
                        Text("system")
                        .font(.footnote)
                    }
                    VStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 50, height: 50)
                        Text("Dark Mode")
                        .font(.footnote)
                    }
                }
//                TODO maybe font size, Icon size, 
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    EditPreferencesView()
}
