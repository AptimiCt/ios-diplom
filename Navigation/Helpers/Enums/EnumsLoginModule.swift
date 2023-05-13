//
//
// EnumsLoginModule.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

enum ButtonsTapped {
    case login
    case registration
    case loginWithBiometrics
    case undefined
}
enum StateView {
    case initial
    case loading
    case success
    case failure
    case keyboardWillShow(NSNotification)
    case keyboardWillHide(NSNotification)
}
enum StateModel {
    case initial
    case loading
    case success(AuthModel)
    case failure(AuthenticationError)
}

enum StateModelProfile {
    case initial
    case loading
    case success(UserData)
    case failure(AuthenticationError)
    case keyboardWillShow(NSNotification)
    case keyboardWillHide(NSNotification)
    
    struct UserData {
        var name: String
        var surname: String
        var gender: String
        var dateOfBirth: Date
        var profilePicture: String
    }

}
