//
//  User.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

import Foundation
import StorageService

protocol UserService{
    func userService(loginName: String) -> User?
}

enum State {
    case initial
    case loaded(ProfileViewModelProtocol)
    case error
}

final class User {
    
    let fullName: String
    var uid: String?
    var avatar: String
    var status: String
    
    init(fullName: String, avatar: String, status: String){
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
    convenience init(authModel: AuthModel) {
        self.init(fullName: authModel.name, avatar: "", status: "")
        self.uid = authModel.uid
    }
}
