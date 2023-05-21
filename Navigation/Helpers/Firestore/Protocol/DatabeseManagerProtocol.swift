//
//
// DatabeseManagerProtocol.swift
// Navigation
//
// Created by Александр Востриков
//
    
protocol DatabeseManagerProtocol {
    var users: [User] { get }
    func addUser(user: User, completion:  @escaping OptionalAuthenticationErrorClosure)
    func fetchUsers(completion:  @escaping OptionalAuthenticationErrorClosure)
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func updateUser(user: User, completion:  @escaping OptionalAuthenticationErrorClosure)
}
