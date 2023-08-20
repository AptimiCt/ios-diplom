//
//
// PostDetailViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

final class PostDetailViewModel: PostDetailViewModelProtocol {
    
    var stateChanged: ((StateModelPost) -> Void)?
    private var post: Post
    private var user: User
    private var postData: StateModelPost.PostData {
        var isLiked = false
        let likes = post.likes
        if likes.contains(user.uid) {
            isLiked = true
        }
        let createdDate = DateFormatter().string(from: post.createdDate)
        return StateModelPost.PostData(uidUser: user.uid,
                                       profilePicture: user.profilePictureUrl,
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
    
    init(firestore: DatabeseManagerProtocol, post: Post, user: User, index: Int) {
        self.firestore = firestore
        self.post = post
        self.user = user
        self.index = index
        self.stateChanged?(.initial)
        Logger.standard.start(on: self)
    }
    func setupView() {
        stateChanged?(.success(postData))
    }
    func likesButtonTapped(){
        let userUID = user.uid
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
