//
//
// FeedViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class FeedViewModel: FeedViewModelProtocol {
    
    enum State {
        case initial
        case loaded(FeedViewModelProtocol)
        case error
    }
    
    private let firestore: DatabeseManagerProtocol
    private let coordinator: FeedCoordinator
    private let userService: UserService
    
    private var posts: [PostFS] = []
    private var postsForDate: [String: [PostFS]] = [:]
    private var friends: [User] = []
    
    var stateChanged: ((FeedViewModel.State) -> Void)?
    
    init(firestore: DatabeseManagerProtocol, coordinator: FeedCoordinator, userService: UserService) {
        stateChanged?(.initial)
        self.firestore = firestore
        self.coordinator = coordinator
        self.userService = userService
    }
    
    func changeState(completion: @escaping () -> ()) {
        var friendsId = userService.friendsId
        friendsId.append(userService.getUser().uid)
        firestore.fetchFriends(friendsIds: friendsId) { [weak self] result in
            switch result {
                case .success(let friends):
                    self?.friends = friends
                    self?.stateChanged?(.loaded(self!))
                case .failure(let error):
                    print("error friends:\(error)")
            }
            completion()
            self?.firestore.fetchAllPosts(uids: friendsId) { result in
                switch result {
                    case .success(let posts):
                        self?.posts = posts.sorted(by: { $0.createdDate > $1.createdDate })
                        self?.stateChanged?(.loaded(self!))
                    case .failure(let error):
                        print("error posts:\(error)")
                }
                completion()
            }
        }
    }
    
    func numberOfRowsInSection() -> Int {
        return posts.count
    }
    func getUser() -> User {
        userService.getUser()
    }
    func getFriens() -> [User] {
        return userService.friends
    }
    func getPostFor(_ indexPath: IndexPath) -> PostFS {
        posts[indexPath.row]
    }
}
