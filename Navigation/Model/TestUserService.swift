//
//  TestUserService.swift
//  Navigation
//
//  Created by Александр Востриков on 25.04.2022.
//

import Foundation
import FirebaseFirestore

final class TestUserService: UserService {

    private let firestore: DatabeseManagerProtocol = FirestoreManager()
    private(set) var user: User?
    
    init() {
        print("TestUserService создан")
    }
    func getUser() -> User {
        guard let user else { return User() }
        return user
    }
    func set(user: User?) {
        self.user = user
    }
    func fetchUser(uid: String, completion: @escaping (User?) -> Void) {
        firestore.fetchUser(uid: uid) { result in
            switch result {
                case .success(let user):
                    self.user = user
                    completion(user)
                case .failure(let failure):
                    print("error TestUserService:\(failure)")
                    completion(nil)
            }
        }
    }
    deinit {
        print("TestUserService удален")
    }
}
