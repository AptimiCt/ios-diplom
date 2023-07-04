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
        var newPost = post
        let usersPostsRef = firestoreDB.collection(usersPosts)
        newPost.postUid = usersPostsRef.collectionID
        do {
            let postDocumentIdRef = try usersPostsRef.addDocument(from: newPost) { error in
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
        let usersPostsRef = firestoreDB.collection(usersPosts)
        usersPostsRef
            .whereField(PostProperties.userUid, in: [uid])
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let self else { completion(.failure(FirestoreDatabaseError.error(desription: "self is nil"))); return}
                    self.posts = querySnapshot!.documents.compactMap { querySnapshotDocument in
                        do {
                            return try querySnapshotDocument.data(as: PostFS.self)
                        } catch {
                            completion(.failure(FirestoreDatabaseError.error(desription: "Не удалось получить пост.")))
                            return nil
                        }
                    }
                    completion(.success(self.posts))
                }
            }
    }
    func fetchAllPosts(uids: [String], completion: @escaping (Result<[PostFS], Error>) -> Void) {
        let usersPostsRef = firestoreDB.collection(usersPosts)
        usersPostsRef
            .whereField(PostProperties.userUid, in: uids)
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let self else { completion(.failure(FirestoreDatabaseError.error(desription: "self is nil"))); return}
                    self.posts = querySnapshot!.documents.compactMap { querySnapshotDocument in
                        do {
                            return try querySnapshotDocument.data(as: PostFS.self)
                        } catch {
                            completion(.failure(FirestoreDatabaseError.error(desription: "Не удалось получить пост.")))
                            return nil
                        }
                    }
                    completion(.success(self.posts))
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

struct PostFS: Codable {
    let userUid: String
    var postUid: String
    let title: String?
    let body: String
    var imageUrl: String?
    var postImageFilename: String {
        return postUid + "_post"
    }
    let likes: [String]
    let views: Int
    let createdDate: Date
    let updateDate: Date
    
    init(userUid: String,
         postUid: String = "",
         title: String? = "",
         body: String,
         imageUrl: String? = nil,
         likes: [String] = [],
         views: Int = 0,
         frends: [String] = [],
         createdDate: Date = Date(),
         updateDate: Date = Date()
    ) {
        self.userUid = userUid
        self.postUid = postUid
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
    case failedToUpload
    case failedToGetDownloadUrl
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
