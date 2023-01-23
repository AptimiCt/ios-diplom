//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

import Foundation

final class CurrentUserService: UserService {
    
    private let user: User
    init() {
        self.user = User(fullName: Constants.currentUserServiceFullName, avatar: Constants.currentUserServiceAvatar, status: Constants.status)
    }
    
    func userService(loginName: String) -> User? {
        
        if loginName == user.fullName  {
            return user
        }
        return nil
    }
}
