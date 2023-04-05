//
//  AuthError.swift
//  Navigation
//
//  Created by Александр Востриков on 16.10.2022.
//

import Foundation

enum CredentialError: String, Error {
    case incorrectCredentials
    case emptyEmail
    case emptyPassword
    case emailIsNoCorrect
}
