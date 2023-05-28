//
//
// DatabeseManagerProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    
protocol DatabeseManagerProtocol {
    func addUser(user: User, completion:  @escaping OptionalErrorClosure)
    func fetchAllUsers(without user: String, completion: @escaping (Result<[User], Error>) -> Void)
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func updateUser(user: User, completion:  @escaping OptionalErrorClosure)
    func addFriend(userId: String, friendId: String, completion: @escaping OptionalErrorClosure)
    func fetchFriends(friendsIds: [String], completion: @escaping (Result<[User], Error>) -> Void)
    func addNewPost(post: PostFS, completion: @escaping OptionalErrorClosure)
    func fetchPost(postId: String, completion: @escaping (Result<PostFS, Error>) -> Void)
    func fetchAllPosts(uid: String, completion: @escaping (Result<[PostFS], Error>) -> Void)
    func updateLike(postId: String, completion: @escaping OptionalErrorClosure)
    func updateViews(postId: String, completion: @escaping OptionalErrorClosure)
}
