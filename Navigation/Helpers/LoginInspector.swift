//
//  LoginInspector.swift
//  Navigation
//
//  Created by Александр Востриков on 25.04.2022.
//

import Foundation

final class LoginInspector: LoginViewControllerDelegate {

    func checkCredentionalsInspector(email: String, password: String, completion: @escaping (Result<AuthModel, AuthenticationError>) -> Void) {
        CheckerService.shared.checkCredentialsService(email: email, password: password) { result, error in
            if error != nil {
                completion(.failure(error!))
            } else {
                let name = Constants.currentUserServiceFullName
                guard let uid = result?.user.uid else { return }
                let authModel = AuthModel(name: name, uid: uid)
                completion(.success(authModel))
            }
        }
    }
    
    func signUpInspector(email: String, password: String, completion: @escaping (Result<AuthModel, AuthenticationError>) -> Void) {
        CheckerService.shared.signUpService(email: email, password: password) { result, error in
            if error != nil {
                completion(.failure(error!))
            } else {
                let name = Constants.currentUserServiceFullName
                guard let uid = result?.user.uid, let email = result?.user.email else { return }
                let authModel = AuthModel(name: name, uid: uid)
                completion(.success(authModel))
            }
        }
    }
}
