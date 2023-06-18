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
    private var post: PostFS
    private var postData: StateModelPost.PostData {
        var isLiked = false
        let likes = post.likes
        if likes.contains(post.userUid) {
            isLiked = true
        }
        let friends = userService.friends
        var user = userService.getUser()
        if user.uid != post.userUid {
            user = friends.first { $0.uid == post.userUid }!
        }
        let createdDate = DateFormatter().string(from: post.createdDate)
        return StateModelPost.PostData(uidUser: post.userUid,
                                       profilePicture: user.avatar ?? Constants.defaultProfilePicture,
                                       fullName: user.getFullName(),
                                       createdDate: createdDate,
                                       uidPost: post.postUid,
                                       body: post.body,
                                       postImage: post.imageUrl,
                                       likes: post.likes.count,
                                       isLiked: isLiked,
                                       views: post.views)
    }
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    private let firestore: DatabeseManagerProtocol
    
    init(userService: UserService, firestore: DatabeseManagerProtocol, post: PostFS) {
        self.userService = userService
        self.firestore = firestore
        self.post = post
        self.stateChanged?(.initial)
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
                                self.stateChanged?(.success(self.postData))
                            case .failure(let error):
                                print("fetchPost:\(error.localizedDescription)")
                        }
                    }
                }
                
            }
        }
    }
}
