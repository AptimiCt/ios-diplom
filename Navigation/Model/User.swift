//
//  User.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

import Foundation

protocol UserService{
    var user: User? { get }
    func getUser() -> User
    func set(user: User?)
    func fetchUser(uid: String, completion: @escaping (User?) -> Void)
}

enum State {
    case initial
    case loaded(ProfileViewModelProtocol)
    case error
}

final class User: Codable {
    
    var uid: String
    var name: String?
    var surname: String?
    var email: String?
    var status: String?
    var gender: String?
    var dateOfBirth: Date?
    var avatar: String?
    var updateDate: Date?
    var createdDate: Date
    
    init(uid: String = UUID().uuidString,
         email: String? = "",
         name: String = "",
         surname: String = "",
         avatar: String = "defaultProfilePicture",
         status: String = "",
         createdDate: Date = Date()
    ) {
        self.uid = uid
        self.name = name
        self.surname = surname
        self.email = email
        self.avatar = avatar
        self.status = status
        self.createdDate = createdDate
    }

    private func getFullName() -> String {
        return "\(String(describing: surname)) \(String(describing: name))"
    }
}
