//
//
// PostDetailViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class PostDetailViewModel: PostDetailViewModelProtocol {
    
    private let userService: UserService
    var stateChanged: ((StateModelPost) -> Void)?
    private var post: Post
    private var postData: StateModelPost.PostData {
        var isLiked = false
        let likes = post.likes
        if likes.contains(userService.getUser().uid) {
            isLiked = true
        }
        let friends = userService.friends
        var user = userService.getUser()
        if user.uid != post.userUid {
            user = friends.first { $0.uid == post.userUid }!
        }
        let createdDate = DateFormatter().string(from: post.createdDate)
        return StateModelPost.PostData(uidUser: post.userUid,
                                       profilePicture: user.profilePictureUrl ?? Constants.defaultProfilePicture,
                                       fullName: user.getFullName(),
                                       createdDate: createdDate,
                                       uidPost: post.postUid,
                                       body: post.body,
                                       postImage: post.imageUrl,
                                       likes: post.likes.count,
                                       isLiked: isLiked,
                                       views: post.views)
    }
    private let index: Int
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    private let firestore: DatabeseManagerProtocol
    
    init(userService: UserService, firestore: DatabeseManagerProtocol, post: Post, index: Int) {
        self.userService = userService
        self.firestore = firestore
        self.post = post
        self.index = index
        self.stateChanged?(.initial)
        Logger.standard.start(on: self)
    }
    func setupView() {
        stateChanged?(.success(postData))
    }
    func likesButtonTapped(){
        let userUID = userService.getUser().uid
        let postUID = postData.uidPost
        if !(post.likes.contains(userUID)) {
            firestore.updateLike(postId: postData.uidPost, from: userUID) { [weak self] error in
                if let error {
                    print("updateLike:\(error.localizedDescription)")
                } else {
                    guard let self else { return }
                    self.firestore.fetchPost(postId: postUID) { result in
                        switch result {
                            case .success(let post):
                                self.post = post
                                let postNotification = ["post": post, "index": self.index] as [String : Any]
                                NotificationCenter.default.post(name: Notification.Name(Constants.notifyForUpdateProfile), object: postNotification)
                                self.stateChanged?(.success(self.postData))
                            case .failure(let error):
                                print("fetchPost:\(error.localizedDescription)")
                        }
                    }
                }
                
            }
        }
    }
    
    deinit {
        Logger.standard.remove(on: self)
    }
}
