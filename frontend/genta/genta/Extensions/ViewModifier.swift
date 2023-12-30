////
////  ViewModifier.swift
////  genta
////
////  Created by Tony Avis on 12/29/23.
////
//
//import Foundation
//import SwiftUI
//
///*
// I want getting warining
// Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
// 
// to fix this I make State variables in the views that match the controller variables and binded them
// */
//
//extension View{
//    //                binding the published values to the state variable so we dont need the .onRecieve and .onChange in the view
//    func syncBool(_ published : Binding<Bool>, with binding: Binding<Bool>)
//    -> some View{
//        self
//            .onChange(of: published.wrappedValue){ published in
//                binding.wrappedValue = published
//            }
//            .onChange(of: binding.wrappedValue){ binding in
//                published.wrappedValue = binding
//            }
//    }
//    
//    func syncString(_ published : Binding<String>, with binding: Binding<String>)
//    -> some View{
//        self
//            .onChange(of: published.wrappedValue){ published in
//                binding.wrappedValue = published
//            }
//            .onChange(of: binding.wrappedValue){ binding in
//                published.wrappedValue = binding
//            }
//    }
//    func syncArrOfMessages(_ published : Binding<[Message]>, with binding: Binding<[Message]>)
//    -> some View{
//        self
//            .onChange(of: published.wrappedValue){ published in
//                binding.wrappedValue = published
//            }
//            .onChange(of: binding.wrappedValue){ binding in
//                published.wrappedValue = binding
//            }
//    }
//    
//    
//}
