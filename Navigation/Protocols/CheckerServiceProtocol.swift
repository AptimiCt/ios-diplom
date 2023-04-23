//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Александр Востриков on 05.10.2022.
//

import Foundation
import FirebaseAuth

protocol CheckerServiceProtocol {
    typealias AuthenticationCompletionBlock = (AuthDataResult?, AuthenticationError?)-> Void
    
    func checkCredentialsService(email: String, password: String, completion: @escaping AuthenticationCompletionBlock)
    func signUpService(email: String, password: String, completion: @escaping AuthenticationCompletionBlock)
}
