//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Александр Востриков on 05.10.2022.
//

import Foundation
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentialsService(email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void)
    func signUpService(email: String, password: String, completion: @escaping (AuthDataResult?, NSError?) -> Void)
}
