//
//  FirebaseResponseError.swift
//  Navigation
//
//  Created by Александр Востриков on 31.10.2022.
//

import Foundation

enum FirebaseResponseError: String {
    case ERROR_NETWORK_REQUEST_FAILED
    case ERROR_USER_NOT_FOUND
    case ERROR_WRONG_PASSWORD
    case ERROR_INVALID_EMAIL
    case ERROR_EMAIL_ALREADY_IN_USE
}
