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
    
    var uid: String?
    var name: String?
    var surname: String?
    var fullName: String
    var status: String?
    var gender: String?
    var dateOfBirth: Date?
    var avatar: String
    var updateDate: Date?
    
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
