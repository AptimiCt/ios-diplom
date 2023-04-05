//
//  CheckerService.swift
//  Navigation
//
//  Created by Александр Востриков on 25.04.2022.
//

import Foundation
import FirebaseAuth

final class CheckerService: CheckerServiceProtocol {
    
    static let shared = CheckerService()
    
    private init () {}
    
    //MARK: - func
    func checkCredentialsService(email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(result, error as? NSError)
        }
    }
    
    func signUpService(email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { createResult, error in
            completion(createResult, error as? NSError)
        }
    }
}
