//
//  DashboardView.swift
//  genta
//
//  Created by Tony Avis on 12/27/23.
//

import SwiftUI


struct DashboardView: View {
    
    //    let user : CDUser
    @FetchRequest(
        entity: CDUser.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "isCurrUser_ == %@", NSNumber(value: true)),
        animation: .default)
    private var users: FetchedResults<CDUser>
    
    @State var loadingScreenTxt : String = "Attempting to log in"
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.actionColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        UIPageControl.appearance().tintColor = UIColor.lightGray
    }
    
    var body: some View {
        if let user = users.first{
            if user.numImgsGenerated_ == user.generatedImages.count{
                // only show the view if the all the images have been downloaded from s3
                TabView {
                    AllGeneratedImgsView(user : user)
                        .background(Color.theme.baseColor)
                    GenerateImgView(user: user)
                        .background(Color.theme.baseColor)
                    SettingsView(user: user)
                        .background(Color.theme.baseColor)
                }
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, 20)
                .frame(
                    width: UIScreen.main.bounds.width ,
                    height: UIScreen.main.bounds.height
                )
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            }else{
                LoadingView(purpose: $loadingScreenTxt)
                    .onChange(of: user.generatedImages.count){
                        // show different text depending on how close the sys is to downloading all users images
                        let percentDownload = (Double(Int64( user.generatedImages.count)) / Double( user.numImgsGenerated_)) * 100
                        print("percent downloaed images",percentDownload)
                        if percentDownload > 50.0{
                            loadingScreenTxt = "Finalizing"
                        }else if percentDownload > 30.0{
                            loadingScreenTxt = "Getting your images"
                        }
                        
                    }
            }
        }
    }
}

//#Preview {
//    DashboardView()
//}
