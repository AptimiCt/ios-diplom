//
//  User.swift
//  Navigation
//
//  Created by Александр Востриков on 23.04.2022.
//

//import StorageService
import FirebaseFirestore

protocol UserService{
    func userService(loginName: String) -> User?
}

enum State {
    case initial
    case loaded(ProfileViewModelProtocol)
    case error
}

final class User {
    
    var uid: String?
    var name: String?
    var surname: String?
    var fullName: String
    var status: String?
    var gender: String?
    var dateOfBirth: Date?
    var avatar: String
    var updateDate: Date?
    
    init(fullName: String, avatar: String, status: String){
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
    init(document: QueryDocumentSnapshot) {
        self.uid = document.data()["uid"] as? String ?? UUID().uuidString
        self.name = document.data()["name"] as? String ?? ""
        self.surname = document.data()["surname"] as? String ?? ""
        self.fullName = "\(self.surname ?? "") \(self.name ?? "")"
        self.status = document.data()["status"] as? String ?? ""
        self.gender = document.data()["gender"] as? String ?? ""
        self.dateOfBirth = (document.data()["dateOfBirth"] as? Timestamp)?.dateValue() ?? Date(timeIntervalSince1970: 0)
        self.avatar = ""
        self.updateDate = document.data()["updateDate"] as? Date ?? Date()
    }
    convenience init(authModel: AuthModel) {
        self.init(fullName: authModel.name, avatar: "", status: "")
        self.uid = authModel.uid
    }
    
    var dictonaryForFirestore: [String: Any?] {
        return [
            "uid" : uid,
            "name" : name,
            "surname" : surname,
            "fullName" : fullName,
            "status" : status,
            "gender" : gender,
            "dateOfBirth" : dateOfBirth,
            "avatar" : avatar,
            "updateDate" : updateDate,
        ]
    }
}
