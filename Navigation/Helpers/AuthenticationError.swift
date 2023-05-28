//
//  AuthenticationError.swift
//  Navigation
//
//  Created by Александр Востриков on 16.10.2022.
//

import Foundation

enum AuthenticationError: Error {
    case incorrectCredentials
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case userNotFound
    case userDisabled
    case loginInUse
    case weakPassword(String)
    case networkError
    case tooManyRequests
    case unknown(String?)
}
extension AuthenticationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .incorrectCredentials:
                return "incorrectCredentials".localized
            case .emptyEmail:
                return "emptyEmail".localized
            case .emptyPassword:
                return "emptyPassword".localized
            case .invalidEmail:
                return "invalidEmail".localized
            case .userNotFound:
                return "userNotFound".localized
            case .userDisabled:
                return "userDisabled".localized
            case .loginInUse:
                return "loginInUse".localized
            case .weakPassword(let reason):
                return "\("weakPassword".localized)\(reason)"
            case .networkError:
                return "networkError".localized
            case .tooManyRequests:
                return "tooManyRequests".localized
            case .unknown(let error):
                return "\("AuthenticationError.unknown".localized). \(error ?? "nil")"
        }
    }
}
