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
    
    private var posts: [Post] = []
    private var postsForDate: [String: [Post]] = [:]
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
        userService.friends.count
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
    func addCoreData(_ index: Int, completion: @escaping BoolClosure) {
        let post = getPostFor(index)
        CoreDataManager.dataManager.create(post: post, for: getUser(for: post.userUid)) { result in
            switch result {
                case .success(_):
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print("error create:\(error.localizedDescription)")
            }
        }
        completion(true)
    }
    func getFriends() -> [User] {
        userService.friends
    }
    func getPostFor(_ index: Int) -> Post {
        posts[index]
    }
    func cellType(at index: Int) -> CellType {
        guard let _ = getPostFor(index).imageUrl else { return .postCell }
        return .postWithImageCell
    }
    func updatePost(post: Post, for index: Int) {
        if posts[index].postUid == post.postUid {
            posts[index] = post
        }
    }
    func newPost(post: Post, for index: Int) {
        posts.insert(post, at: index)
    }
    func didSelectRow(at index: Int) {
        let post = posts[index]
        coordinator.showDetail(post: post, user: userService.getUser(), index: index)
        updateViews(postUID: post.postUid) { [weak self] in
            guard let self else { return }
            self.firestore.fetchPost(postId: post.postUid) { result in
                switch result {
                    case .success(let post):
                        self.posts[index] = post
                        self.stateChanged?(.loaded(self))
                    case .failure(let error):
                        print("error updateViews:\(error.localizedDescription)")
                        return
                }
            }
        }
    }
    func likesButtonTapped(at index: Int) {
        let userUID = userService.getUser().uid
        let post = getPostFor(index)
        let postUID = post.postUid
        print("post.likes upp:\(post.likes)")
        if !(post.likes.contains(userUID)) {
            firestore.updateLike(postId: postUID, from: userUID) { [weak self] error in
                if let error {
                    print("updateLike:\(error.localizedDescription)")
                } else {
                    guard let self else { return }
                    self.firestore.fetchPost(postId: postUID) { result in
                        switch result {
                            case .success(let post):
                                self.posts[index] = post
                                let postNotification = ["post": post, "index": index] as [String : Any]
                                NotificationCenter.default.post(name: Notification.Name(Constants.notifyForUpdateProfile), object: postNotification)
                                self.stateChanged?(.loaded(self))
                                print("post.likes apter:\(post.likes)")
                            case .failure(let error):
                                print("fetchPost:\(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
private extension FeedViewModel {
    private func updateViews(postUID: String, completion: @escaping VoidClosure) {
        firestore.updateViews(postId: postUID) { error in
            if let error {
                print("error updateViews:\(error.localizedDescription)")
                return
            }
            completion()
        }
    }
}
