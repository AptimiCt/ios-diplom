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

    func checkCredentialsService(email: String, password: String, completion: @escaping AuthenticationCompletionBlock) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            if let error = error as NSError?,
               let code = AuthErrorCode.Code(rawValue: error.code)
            {
//                print("Code:\(code), error:\(error.localizedDescription)")
                completion(authDataResult, self?.handleCommonError(code: code, error: error))
            } else {
                completion(authDataResult, nil)
            }
        }
    }
    
    func signUpService(email: String, password: String, completion: @escaping AuthenticationCompletionBlock) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] createResult, error in
            
            if let error = error as NSError?,
               let code = AuthErrorCode.Code(rawValue: error.code)
            {
//                print("Code:\(code), error:\(error.localizedDescription)")
                completion(createResult, self?.handleCommonError(code: code, error: error))
            } else {
                completion(createResult, nil)
            }
        }
    }
    
    private func handleCommonError(code: AuthErrorCode.Code, error: NSError) -> AuthenticationError {
        switch code {
            case .wrongPassword:
                return .incorrectCredentials
            case .invalidEmail:
                return .invalidEmail
            case .userNotFound:
                return .userNotFound
            case .userDisabled:
                return .userDisabled
            case .emailAlreadyInUse:
                return .loginInUse
            case .weakPassword:
                if let reason = error.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
                    return .weakPassword(reason)
                } else {
                    print("error.userInfo_weakPassword:\(error.userInfo)")
                    return .unknown("error.userInfo_default:\(error.userInfo)")
                }
            case .networkError:
                return .networkError
            case .tooManyRequests:
                return .tooManyRequests
           
            default:
                print("error.userInfo_default:\(error.userInfo)")
                return .unknown("error.userInfo_default:\(error.userInfo)")
            
        }
    }
}
