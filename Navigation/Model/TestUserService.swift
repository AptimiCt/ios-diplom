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
    
    var friends: [User] = []
    
    var friendsId: [String] {
        getUser().friends
    }
    
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
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        firestore.fetchUser(uid: uid) { [weak self] result in
            switch result {
                case .success(let user):
                    self?.user = user
                    completion(.success(user))
                case .failure(let failure):
                    print("error TestUserService User:\(failure)")
                    completion(.failure(failure))
            }
        }
    }
    func fetchFiends(completion: @escaping () -> Void) {
        firestore.fetchFriends(friendsIds: friendsId) { [weak self] result in
            switch result {
                case .success(let friends):
                    self?.friends = friends
                case .failure(let error):
                    print("error TestUserService Fiends:\(error)")
            }
            completion()
        }
    }
    
    deinit {
        print("TestUserService удален")
    }
}
