//
//  User.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

import Foundation

protocol UserService {
    var user: User? { get }
    var friendsId: [String] { get }
    var friends: [User] { get set }
    func getUser() -> User
    func set(user: User?)
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func fetchFiends(completion: @escaping () -> Void)
}

final class User: Codable {
    
    let uid: String
    var name: String
    var surname: String
    let email: String?
    let status: String?
    var gender: String
    var dateOfBirth: Date
    var profilePictureUrl: String?
    var profilePictureFilename: String {
        return uid + "_profilePicture.jpg"
    }
    let posts: [String]
    let friends: [String]
    var updateDate: Date
    let createdDate: Date
    
    init(uid: String = UUID().uuidString,
         email: String? = "",
         name: String = "",
         surname: String = "",
         profilePicture: String = Constants.defaultProfilePicture,
         status: String = "",
         gender: String = "undefined",
         dateOfBirth: Date = Date(),
         posts: [String] = [],
         friends: [String] = [],
         updateDate: Date = Date(),
         createdDate: Date = Date()
    ) {
        self.uid = uid
        self.name = name
        self.surname = surname
        self.email = email
        self.profilePictureUrl = profilePicture
        self.status = status
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.posts = posts
        self.friends = friends
        self.updateDate = updateDate
        self.createdDate = createdDate
    }

    func getFullName() -> String {
        return "\(String(describing: surname)) \(String(describing: name))"
    }
}
