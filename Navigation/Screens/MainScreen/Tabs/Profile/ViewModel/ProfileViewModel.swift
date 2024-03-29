//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Александр Востриков on 06.01.2023.
//

import UIKit

final class ProfileViewModel: ProfileViewModelProtocol {
    
    enum State {
        case initial
        case loaded(ProfileViewModelProtocol)
        case error
    }
    
    private let firestore: DatabeseManagerProtocol
    private weak var coordinator: ProfileCoordinator!
    private let userService: UserService
    
    private var posts: [Post] = []
    private var photos: [UIImage] = [] {
        didSet {
            stateChanged?(.loaded(self))
        }
    }
    
    var stateChanged: ((ProfileViewModel.State) -> Void)?

    init(firestore: DatabeseManagerProtocol, coordinator: ProfileCoordinator, userService: UserService) {
        stateChanged?(.initial)
        self.firestore = firestore
        self.coordinator = coordinator
        self.userService = userService
        DispatchQueue.global().async {
            Photos.fetchPhotos { [weak self] photos in
                guard let self else { return }
                self.photos = photos
                self.stateChanged?(.loaded(self))
            }
        }
    }
    
    func changeState(completion: @escaping VoidClosure) {
        let userId = getUser().uid
        firestore.fetchAllPosts(uid: userId) { [weak self] result in
            guard let self else { completion(); return }
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
    func newPost(post: Post, for index: Int) {
        posts.insert(post, at: index)
        stateChanged?(.loaded(self))
    }
    func updatePost(post: Post, for index: Int) {
        if index < numberOfRows(), posts[index].postUid == post.postUid {
            posts[index] = post
            stateChanged?(.loaded(self))
        }
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
        if !(post.likes.contains(userUID)) {
            firestoreUpdateLike(postUID: postUID, from: userUID, IslikeAdded: true, for: index)
        } else {
            firestoreUpdateLike(postUID: postUID, from: userUID, IslikeAdded: false, for: index)
        }
    }
    func numberOfRows() -> Int {
        posts.count
    }
    func getPostFor(_ index: Int) -> Post {
        posts[index]
    }
    func cellType(at index: Int) -> CellType {
        guard let _ = getPostFor(index).imageUrl else { return .postCell }
        return .postWithImageCell
    }
    func getUser() -> User {
        userService.getUser()
    }
    func addCoreData(_ index: Int, completion: @escaping BoolClosure) {
        let post = getPostFor(index)
        CoreDataManager.dataManager.create(post: post, for: getUser()) { result in
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
    func getPhotos() -> [UIImage] {
        photos
    }
    func showPhotosVC() {
        coordinator.showPhotosVC()
    }
    func showEditProfileVC() {
        coordinator.showEditProfileVC()
    }
    func showFindFriendVC() {
        coordinator.showFindFriendVC()
    }
    func showAddPostVC() {
        coordinator.showAddPostVC()
    }
    func showAddPhoto() {
        print(#function)
    }
    func finishFlow() {
        coordinator.finishFlow?(nil)
    }
}
private extension ProfileViewModel {
    private func updateViews(postUID: String, completion: @escaping VoidClosure) {
        firestore.updateViews(postId: postUID) { error in
            if let error {
                print("error updateViews:\(error.localizedDescription)")
                return
            }
            completion()
        }
    }
    func firestoreUpdateLike(postUID: String, from userUID: String, IslikeAdded: Bool, for index: Int) {
        firestore.updateLike(postId: postUID, from: userUID, IslikeAdded: IslikeAdded) { [weak self] error in
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
                        case .failure(let error):
                            print("fetchPost:\(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
