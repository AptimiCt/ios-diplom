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
            guard let self else { return }
            switch result {
                case .success(let friends):
                    self.friends = friends
                    self.stateChanged?(.loaded(self))
                case .failure(let error):
                    print("error friends:\(error)")
            }
            completion()
            self.firestore.fetchAllPosts(uids: friendsId) { result in
                switch result {
                    case .success(let posts):
                        self.posts = posts.sorted(by: { $0.createdDate > $1.createdDate })
                        self.stateChanged?(.loaded(self))
                    case .failure(let error):
                        print("error posts:\(error)")
                }
                completion()
            }
        }
    }
    func numberOfRows() -> Int {
        posts.count
    }
    func numberOfSections() -> Int {
        friends.count
    }
    func getUser(for userUID: String) -> User {
        let friends = userService.friends
        var user = userService.getUser()
        if user.uid != userUID, !friends.isEmpty {
            guard let friend = friends.first(where: { $0.uid == userUID }) else { return user }
            user = friend
        }
        return user
    }
    func getFriens() -> [User] {
        userService.friends
    }
    func getPostFor(_ indexPath: IndexPath) -> PostFS {
        posts[indexPath.row]
    }
    func cellType(at indexPath: IndexPath) -> CellType {
        guard let _ = getPostFor(indexPath).imageUrl else { return .postCell }
        return .postWithImageCell
    }
    func showDetail(post: PostFS) {
        coordinator.showDetail(post: post)
    }
    func didSelectRow(at indexPath: IndexPath) {
        let post = posts[indexPath.row]
        coordinator.showDetail(post: post)
        updateViews(postUID: post.postUid) { [weak self] in
            guard let self else { return }
            self.firestore.fetchPost(postId: post.postUid) { result in
                switch result {
                    case .success(let post):
                        self.posts[indexPath.row] = post
                        self.stateChanged?(.loaded(self))
                    case .failure(let error):
                        print("error updateViews:\(error.localizedDescription)")
                        return
                }
            }
        }
    }
    func updateViews(postUID: String, completion: @escaping VoidClosure) {
        firestore.updateViews(postId: postUID) { error in
            if let error {
                print("error updateViews:\(error.localizedDescription)")
                return
            }
            completion()
        }
    }
}
