//
//
// PostDetailViewModelWithComments.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class PostDetailViewModelWithComments: PostDetailViewModelWithCommentsProtocol {
    
    var stateChanged: ((StateModelPostWithComments) -> Void)?
    private var post: Post
    private var user: User
    private var comments: [Comment] = []
    private var userForComments: [String : User] = [:]
    private var postData: StatePostView.PostData {
        var isLiked = false
        let likes = post.likes
        if likes.contains(uidForLike) {
            isLiked = true
        }
        let createdDate = DateFormatter().string(from: post.createdDate)
        
        return StatePostView.PostData(uidUser: user.uid,
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
    private let uidForLike: String
    private let index: Int
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    private let firestore: DatabeseManagerProtocol
    
    init(firestore: DatabeseManagerProtocol, post: Post, user: User, uidForLike: String = "", index: Int) {
        self.firestore = firestore
        self.post = post
        self.user = user
        self.uidForLike = uidForLike
        self.index = index
        self.stateChanged?(.initial)
        Logger.standard.start(on: self)
    }
    func setupView() {
        stateChanged?(.success(self))
    }
    func changeState(completion: @escaping VoidClosure) {
        firestore.fetchPost(postId: post.postUid) { [weak self] result in
            guard let self else { completion(); return }
            switch result {
                case .success(let loadedPost):
                    self.updatePost(post: loadedPost)
                case .failure(let error):
                    print("error load post:\(error)")
                    completion()
            }
            firestore.fetchAllComments(for: post) { result in
                        switch result {
                            case .success(let commentsData):
                                self.comments = commentsData.comments
                                self.userForComments = commentsData.users
                            case .failure(let error):
                                print("error for success:\(error.localizedDescription)")
                        }
                completion()
            }
        }
    }
    func getPost() -> StatePostView.PostData {
        self.postData
    }
    func numberOfRows() -> Int {
        comments.count
    }
    func getComment(at index: Int) -> CommentDataCell {
        let comment = comments[index]
        let user = userForComments[comment.userUid] ?? User()
        return CommentDataCell(comment: comment, user: user)
    }
    func likesButtonTapped(){
        let postUID = post.postUid
        if !(post.likes.contains(uidForLike)) {
            firestore.updateLike(postId: postUID, from: uidForLike) { [weak self] error in
                if let error {
                    print("updateLike:\(error.localizedDescription)")
                } else {
                    guard let self else { return }
                    self.firestore.fetchPost(postId: postUID) { result in
                        switch result {
                            case .success(let loadedPost):
                                self.updatePost(post: loadedPost)
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

private extension PostDetailViewModelWithComments {
    func updatePost(post: Post) {
        self.post = post
        let postNotification = ["post": post, "index": self.index] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name(Constants.notifyForUpdateProfile), object: postNotification)
        self.stateChanged?(.success(self))
    }
}
