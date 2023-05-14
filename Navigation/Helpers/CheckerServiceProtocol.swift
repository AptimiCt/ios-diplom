//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Александр Востриков on 05.10.2022.
//

protocol CheckerServiceProtocol {
    func checkCredentialsService(email: String, password: String, completion: @escaping AuthenticationCompletionBlock)
    func signUpService(email: String, password: String, completion: @escaping AuthenticationCompletionBlock)
}
