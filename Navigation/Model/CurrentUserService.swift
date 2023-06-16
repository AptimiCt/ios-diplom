//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

import Foundation

final class CurrentUserService: UserService {
    func fetchFiends(completion: @escaping () -> Void) {
        
    }
    
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        
    }
    
    var friendsId: [String] = []
    
    private let firestore: DatabeseManagerProtocol = FirestoreManager()
    private(set) var user: User?
    var friends: [User] = []
    init() {
        print("CurrentUserService создан")
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
        print("CurrentUserService удален")
    }
}
