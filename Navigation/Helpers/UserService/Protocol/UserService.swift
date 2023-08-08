//
//
// UserService.swift
// Navigation
//
// Created by Александр Востриков
//
    

protocol UserService {
    var user: User? { get }
    var friendsId: [String] { get }
    var friends: [User] { get set }
    func getUser() -> User
    func set(user: User?)
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func fetchFriends(completion: @escaping () -> Void)
}
