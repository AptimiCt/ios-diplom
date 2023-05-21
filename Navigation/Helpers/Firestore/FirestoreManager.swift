//
//
// FirestoreManager.swift
// Navigation
//
// Created by Александр Востриков
//
    
import FirebaseFirestore
import FirebaseFirestoreSwift

final class FirestoreManager: DatabeseManagerProtocol {

    private let firestoreDB = Firestore.firestore()
    private var usersCollection: String = FirestoreCollection.usersCollection.rawValue
    
    var users: [User] = []
     
    func addUser(user: User, completion: @escaping OptionalAuthenticationErrorClosure) {
        let uid = user.uid
        let docRef = firestoreDB.collection(usersCollection).document(uid)
        do {
            try docRef.setData(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let docRef = firestoreDB.collection(usersCollection).document(uid)
        docRef.getDocument(as: User.self) { result in
            completion(result)
        }
    }
 
    func fetchUsers(completion: @escaping OptionalAuthenticationErrorClosure) {
        
        let docRef = firestoreDB.collection(usersCollection)
        
        docRef.getDocuments { [weak self] querySnapshot, error in
            
            if let error { completion(error); return }
            guard let self, let querySnapshot else { completion(nil); return }
            
            self.users = querySnapshot.documents.compactMap({ querySnapshot in
                do {
                    return try querySnapshot.data(as: User.self)
                } catch {
                    print(error)
                }
                return nil
            })
            for user in self.users {
                print("user.uid FirestoreManager:\(user.uid)")
            }
            completion(nil)
        }
    }
    
    func updateUser(user: User, completion: @escaping OptionalAuthenticationErrorClosure) {
        let uid = user.uid
        let docRef = firestoreDB.collection(usersCollection).document(uid)
        do {
            try docRef.setData(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
