//
//
// FirestoreManager.swift
// Navigation
//
// Created by Александр Востриков
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreManager {
    
    private let firestoreDB = Firestore.firestore()
    private let usersCollection: String = FirestoreCollection.usersCollection
    private let usersPosts: String = FirestoreCollection.usersPosts
    private var users: [User] = []
    private var posts: [PostFS] = []
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
                    completion(.failure(FirestoreDatabaseError.error(desription: "self or querySnapshot is nil")))
                    return }
                let fitredQuerySnapshotDocuments = user.isEmpty ? querySnapshotDocuments :  querySnapshotDocuments.filter { $0.documentID != user }
                self.users = fitredQuerySnapshotDocuments.compactMap { querySnapshot in
                    do {
                        return try querySnapshot.data(as: User.self)
                    } catch {
                        completion(.failure(FirestoreDatabaseError.error(desription: "Не удалось получить пользователя")))
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
    func fetchFriends(friendsIds: [String], completion: @escaping (Result<[User], Error>) -> Void) {
        self.users = []
        let usersCollectionRef = firestoreDB.collection(usersCollection)
        usersCollectionRef.getDocuments { [weak self] (querySnapshot, error) in
            if let error {
                completion(.failure(error))
            } else {
                guard let self, let querySnapshotDocuments = querySnapshot?.documents else {
                    completion(.failure(FirestoreDatabaseError.error(desription: "self or querySnapshot is nil")))
                    return }
                let fitredQuerySnapshotDocuments = querySnapshotDocuments.filter({ friendsIds.contains($0.documentID) })
                self.users = fitredQuerySnapshotDocuments.compactMap { querySnapshot in
                    do {
                        return try querySnapshot.data(as: User.self)
                    } catch {
                        completion(.failure(FirestoreDatabaseError.error(desription: "Не удалось получить пользователя")))
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
    
    func addNewPost(post: PostFS, completion: @escaping OptionalErrorClosure) {
        let usersPostsRef = firestoreDB.collection(usersPosts)
        do {
            let postDocumentIdRef = try usersPostsRef.addDocument(from: post) { error in
                if error != nil {
                    completion(error)
                }
            }
            let usersCollectionDocumentRef = firestoreDB.collection(usersCollection).document(post.userUid)
            let posts = [UserProperties.posts : FieldValue.arrayUnion([postDocumentIdRef.documentID])]
            usersCollectionDocumentRef.updateData(posts) { error in
                if error != nil {
                    usersPostsRef.document(postDocumentIdRef.documentID).delete()
                }
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func fetchPost(postId: String, completion: @escaping (Result<PostFS, Error>) -> Void) {
        let usersPostsDocumentRef = firestoreDB.collection(usersPosts).document(postId)
        usersPostsDocumentRef.getDocument(as: PostFS.self) { result in
            completion(result)
        }
    }
    func fetchAllPosts(uid: String, completion: @escaping (Result<[PostFS], Error>) -> Void) {
        self.posts = []
        let usersPostsRef = firestoreDB.collection(usersPosts)
        usersPostsRef
            .whereField(PostProperties.userUid, isEqualTo: uid)
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let self else { completion(.failure(FirestoreDatabaseError.error(desription: "self is nil"))); return}
                    self.posts = querySnapshot!.documents.compactMap { querySnapshot in
                        do {
                            return try querySnapshot.data(as: PostFS.self)
                        } catch {
                            completion(.failure(FirestoreDatabaseError.error(desription: "Не удалось получить пост.")))
                            return nil
                        }
                    }
                    completion(.success(self.posts))
                }
            }
    }
    func updateLike(postId: String, completion: @escaping OptionalErrorClosure) {
        let usersPostsDocumentRef = firestoreDB.collection(usersPosts).document(postId)
        let likes = [PostProperties.likes: FieldValue.increment(Int64(1))]
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
}
struct PostFS: Codable {
    let userUid: String
    let title: String?
    let body: String
    let imageUrl: String?
    let likes: Int
    let views: Int
    let createdDate: Date
    let updateDate: Date
    
    init(userUid: String,
         title: String? = "",
         body: String,
         imageUrl: String? = nil,
         likes: Int = 0, views: Int = 0,
         frends: [String] = [],
         createdDate: Date = Date(),
         updateDate: Date = Date()
    ) {
        self.userUid = userUid
        self.title = title
        self.body = body
        self.imageUrl = imageUrl
        self.likes = likes
        self.views = views
        self.createdDate = createdDate
        self.updateDate = updateDate
    }
}

enum FirestoreDatabaseError: Error {
    case failureGetPost
    case error(desription: String)
}

enum UserProperties {
    static let uid = "uid"
    static let posts = "posts"
    static let friends = "friends"
}
enum PostProperties {
    static let userUid = "userUid"
    static let body = "body"
    static let imageUrl = "imageUrl"
    static let likes = "likes"
    static let views = "views"
}
