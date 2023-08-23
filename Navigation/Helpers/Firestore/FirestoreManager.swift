//
//
// FirestoreManager.swift
// Navigation
//
// Created by Александр Востриков
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

final class FirestoreManager {
    
    private let firestoreDB = Firestore.firestore()
    private let firebaseStorage = FirebaseStorage.Storage.storage().reference()
    private let profilePictureURL: String = FirestoreCollection.profilePictureURL
    private let postPictureURL: String = FirestoreCollection.postPictureURL
    private let usersCollection: String = FirestoreCollection.usersCollection
    private let usersPosts: String = FirestoreCollection.usersPosts
    private let commentsForPosts: String = FirestoreCollection.commentsForPosts
    private var users: [User] = []
    private var posts: [Post] = []
    private var comments: [Comment] = []
    private var usersForPost: [String: User] = [:]
}
extension FirestoreManager: DatabeseManagerProtocol {
    func addUser(user: User, completion: @escaping OptionalErrorClosure) {
        let uid = user.uid
        let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(uid)
        do {
            try usersCollectionDocumentRef.setData(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(uid)
        usersCollectionDocumentRef.getDocument(as: User.self) { result  in
            switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    func fetchAllUsers(without user: String = "", completion: @escaping (Result<[User], Error>) -> Void) {
        self.users = []
        let usersCollectionRef = firestoreDB.collection(usersCollection)
        usersCollectionRef.getDocuments { [weak self] querySnapshot, error in
            if let error {
                completion(.failure(error))
            } else {
                guard let self, let querySnapshotDocuments = querySnapshot?.documents else {
                    completion(.failure(FirestoreDatabaseError.error(description: "self or querySnapshot is nil")))
                    return }
                let filteredQuerySnapshotDocuments = user.isEmpty ? querySnapshotDocuments :  querySnapshotDocuments.filter { $0.documentID != user }
                self.users = filteredQuerySnapshotDocuments.compactMap { querySnapshot in
                    do {
                        return try querySnapshot.data(as: User.self)
                    } catch {
                        completion(.failure(FirestoreDatabaseError.error(description: "Не удалось получить пользователя")))
                        return nil
                    }
                }
                completion(.success(self.users))
            }
        }
    }
    func addFriend(userId: String, friendId: String, completion: @escaping OptionalErrorClosure) {
        let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(userId)
        let friends = [UserProperties.friends: FieldValue.arrayUnion([friendId])]
        usersCollectionDocumentRef.updateData(friends) { error in
            completion(error)
        }
    }
    func removeFromFriend(userId: String, friendId: String, completion: @escaping OptionalErrorClosure) {
        let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(userId)
        let friends = [UserProperties.friends: FieldValue.arrayRemove([friendId])]
        usersCollectionDocumentRef.updateData(friends) { error in
            completion(error)
        }
    }
    func fetchFriends(friendsIds: [String], completion: @escaping (Result<[User], Error>) -> Void) {
        self.users = []
        let usersCollectionRef = firestoreDB.collection(usersCollection)
        usersCollectionRef.getDocuments { [weak self] (querySnapshot, error) in
            if let error {
                completion(.failure(error))
            } else {
                guard let self, let querySnapshotDocuments = querySnapshot?.documents else {
                    completion(.failure(FirestoreDatabaseError.error(description: "self or querySnapshot is nil")))
                    return }
                let filteredQuerySnapshotDocuments = querySnapshotDocuments.filter({ friendsIds.contains($0.documentID) })
                self.users = filteredQuerySnapshotDocuments.compactMap { querySnapshot in
                    do {
                        return try querySnapshot.data(as: User.self)
                    } catch {
                        completion(.failure(FirestoreDatabaseError.error(description: "Не удалось получить пользователя")))
                        return nil
                    }
                }
                completion(.success(self.users))
            }
        }
    }
    func updateUser(user: User, completion: @escaping OptionalErrorClosure) {
        let uid = user.uid
        let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(uid)
        do {
            try usersCollectionDocumentRef.setData(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func addNewPost(post: Post, completion: @escaping OptionalErrorClosure) {
        var newPost = post
        let usersPostsRef = firestoreDB.collection(usersPosts)
        let documentID = usersPostsRef.document().documentID
        newPost.postUid = documentID
        do {
            try usersPostsRef.document(documentID).setData(from: newPost) { error in
                if error != nil {
                    completion(error)
                }
            }
            let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(post.userUid)
            let posts = [UserProperties.posts : FieldValue.arrayUnion([documentID])]
            usersCollectionDocumentRef.updateData(posts) { error in
                if error != nil {
                    usersPostsRef.document(documentID).delete()
                }
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func addCommentForPost(comment: Comment, completion: @escaping OptionalErrorClosure) {
        let commentsForPostsRef = firestoreDB.collection(commentsForPosts)
        let documentID = commentsForPostsRef.document().documentID
        do {
            try commentsForPostsRef.document(documentID).setData(from: comment) { error in
                if error != nil {
                    completion(error)
                }
            }
            let usersPostsRef = firestoreDB.collection(usersPosts).document(comment.postUid)
            let post = [PostProperties.comments : FieldValue.arrayUnion([documentID])]
            usersPostsRef.updateData(post) { error in
                if error != nil {
                    commentsForPostsRef.document(documentID).delete()
                }
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func fetchPost(postId: String, completion: @escaping (Result<Post, Error>) -> Void) {
        let usersPostsDocumentRef = firestoreDB.collection(usersPosts).document(postId)
        usersPostsDocumentRef.getDocument(as: Post.self) { result in
            completion(result)
        }
    }
    func fetchAllPosts(uid: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        let usersPostsRef = firestoreDB.collection(usersPosts)
        usersPostsRef
            .whereField(PostProperties.userUid, in: [uid])
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let self else { completion(.failure(FirestoreDatabaseError.error(description: "self is nil"))); return}
                    self.posts = querySnapshot!.documents.compactMap { querySnapshotDocument in
                        do {
                            return try querySnapshotDocument.data(as: Post.self)
                        } catch {
                            completion(.failure(FirestoreDatabaseError.error(description: "Не удалось получить пост.")))
                            return nil
                        }
                    }
                    completion(.success(self.posts))
                }
            }
    }
    func fetchAllPosts(uids: [String], completion: @escaping (Result<[Post], Error>) -> Void) {
        let usersPostsRef = firestoreDB.collection(usersPosts)
        usersPostsRef
            .whereField(PostProperties.userUid, in: uids)
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let self else { completion(.failure(FirestoreDatabaseError.error(description: "self is nil"))); return}
                    self.posts = querySnapshot!.documents.compactMap { querySnapshotDocument in
                        do {
                            return try querySnapshotDocument.data(as: Post.self)
                        } catch {
                            completion(.failure(FirestoreDatabaseError.error(description: "Не удалось получить пост.")))
                            return nil
                        }
                    }
                    completion(.success(self.posts))
                }
            }
    }
    func fetchAllComments(for post: Post, completion: @escaping (Result<CommentData, Error>) -> Void) {
        self.comments = []
        fetchPost(postId: post.postUid) { [weak self] result in
            guard let self else { completion(.failure(FirestoreDatabaseError.error(description: "self is nil"))); return}
            switch result {
                case .success(let loadedPost):
                    self.fetchComments(for: loadedPost.comments) { result in
                        switch result {
                            case .success(let comments):
                                self.fetchAllUsers { result in
                                    switch result {
                                        case .success(let users):
                                            self.usersForPost = comments.reduce(into: [String: User]()) { dictionary, comment in
                                                if let user = users.first(where: { $0.uid == comment.userUid }) {
                                                    dictionary[comment.userUid] = user
                                                }
                                            }
                                            let commentsData = CommentData(comments: comments, users: self.usersForPost)
                                            completion(.success(commentsData))
                                        case .failure(let error):
                                            completion(.failure(error))
                                    }
                                }
                            case .failure(let error):
                                print("error for success:\(error.localizedDescription)")
                                completion(.failure(error))
                        }
                    }
                case .failure(_):
                    self.fetchComments(for: post.comments) { result in
                        switch result {
                            case .success(let comments):
                                self.fetchAllUsers { result in
                                    switch result {
                                        case .success(let users):
                                            self.usersForPost = comments.reduce(into: [String: User]()) { dictionary, comment in
                                                if let user = users.first(where: { $0.uid == comment.userUid }) {
                                                    dictionary[comment.userUid] = user
                                                }
                                            }
                                            let commentsData = CommentData(comments: comments, users: self.usersForPost)
                                            completion(.success(commentsData))
                                        case .failure(let error):
                                            completion(.failure(error))
                                    }
                                }
                            case .failure(let error):
                                print("error for success:\(error.localizedDescription)")
                                completion(.failure(error))
                        }
                    }
            }
        }
    }
    func updateLike(postId: String, from userUID: String, completion: @escaping OptionalErrorClosure) {
        let usersPostsDocumentRef = firestoreDB.collection(usersPosts).document(postId)
        let likes = [PostProperties.likes: FieldValue.arrayUnion([userUID])]
        usersPostsDocumentRef.updateData(likes) { error in
            completion(error)
        }
    }
    func updateViews(postId: String, completion: @escaping OptionalErrorClosure) {
        let usersPostsDocumentRef = firestoreDB.collection(usersPosts).document(postId)
        let views = [PostProperties.views: FieldValue.increment(Int64(1))]
        usersPostsDocumentRef.updateData(views) { error in
            completion(error)
        }
    }
    func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        
        let profilePictureRef = firebaseStorage.child(profilePictureURL).child(fileName)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        profilePictureRef.putData(data, metadata: uploadMetadata) { downloadMetadata, error in
            if let error {
                print("failed to upload data to firebase for profile picture")
                print("error:\(error)")
                completion(.failure(FirestoreDatabaseError.failedToUpload))
                return
            }
            profilePictureRef.downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(FirestoreDatabaseError.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            })
        }
    }
    func uploadPostPicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        let postPictureRef = firebaseStorage.child(postPictureURL).child(fileName)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        postPictureRef.putData(data, metadata: uploadMetadata) { downloadMetadata, error in
            if let error {
                print("failed to upload data to firebase for post picture")
                print("error:\(error)")
                completion(.failure(FirestoreDatabaseError.failedToUpload))
                return
            }
            postPictureRef.downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(FirestoreDatabaseError.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                completion(.success(urlString))
            })
        }
    }
}
private extension FirestoreManager {
    func fetchComments(for uids: [String], completion: @escaping (Result<[Comment], Error>) -> Void) {
        let commentsForPostsRef = firestoreDB.collection(commentsForPosts)
        commentsForPostsRef.addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let self else { completion(.failure(FirestoreDatabaseError.error(description: "self is nil"))); return}
                self.comments = querySnapshot!.documents.compactMap { querySnapshotDocument in
                    do {
                        return try querySnapshotDocument.data(as: Comment.self)
                    } catch {
                        completion(.failure(FirestoreDatabaseError.error(description: "Не удалось получить комментарий.")))
                        return nil
                    }
                }
                completion(.success(self.comments))
            }
        }
    }
}
