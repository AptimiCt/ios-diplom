//
//  TestUserService.swift
//  Navigation
//
//  Created by Александр Востриков on 25.04.2022.
//

import Foundation

final class TestUserService: UserService {
    func userService(loginName: String) -> User? {
        return User(fullName: Constants.testUserServiceFullName, avatar: Constants.testUserServiceAvatar, status: Constants.status)
    }
}
