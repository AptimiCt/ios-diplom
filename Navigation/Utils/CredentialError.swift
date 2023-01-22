//
//  AuthError.swift
//  Navigation
//
//  Created by Александр Востриков on 16.10.2022.
//

import Foundation

enum CredentialError: String, Error {
    case incorrectCredentials = "Не корректные учетные данные"
    case emptyEmail = "Пустой email"
    case emptyPassword = "Пустой пароль"
    case emailIsNoCorrect = "Не корректный email"
}
