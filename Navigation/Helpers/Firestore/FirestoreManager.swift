//
//
// FirestoreManager.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    
    private let db = Firestore.firestore()
    private var fcUsers: String = FirestoreCollection.users.rawValue
    
    var users: [User] = []
     
    func addUser(user: User, completion: @escaping OptionalAuthenticationErrorClosure) {
        db.collection(fcUsers).addDocument(data: user.dictonaryForFirestore as [String : Any]) { error in
            completion(.unknown(error?.localizedDescription))
        }
    }
    
    func getUsers(completion: @escaping OptionalAuthenticationErrorClosure) {
        db.collection(fcUsers).getDocuments { [weak self] querySnapshot, error in
            if let error { completion(.unknown(error.localizedDescription)); return }
            guard let querySnapshot else { completion(.unknown("querySnapshot is nil")); return }
            self?.users = []
            for document in querySnapshot.documents {
                let user = User(document: document)
                self?.users.append(user)
            }
            completion(.unknown(nil))
        }
    }
    
}
