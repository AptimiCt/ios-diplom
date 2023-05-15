//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

import Foundation

final class CurrentUserService: UserService {
    
    private let user: User
    private let firestore: FirestoreManager
    
    init() {
        self.firestore = FirestoreManager()
        self.user = User(fullName: Constants.currentUserServiceFullName, avatar: Constants.currentUserServiceAvatar, status: Constants.status)
    }
    
    func userService(loginName: String) -> User? {
//        firestore.addUser(user: user) { err in
//            print(err)
//        }
        
        firestore.getUsers { err in
            print(self.firestore.users.first?.status)
            print(err)
        }
        if loginName == user.fullName  {
            return user
        }
        return nil
    }
}
