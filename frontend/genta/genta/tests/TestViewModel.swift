//
//  TestViewModel.swift
//  genta
//
//  Created by Tony Avis on 1/5/24.
//

import Foundation


class TestViewModel : ObservableObject{

    let user : User
    let userServices : UserServices
    
    init(user: User, userServices: UserServices) {
        self.user = user
        self.userServices = userServices
    }
    
}
