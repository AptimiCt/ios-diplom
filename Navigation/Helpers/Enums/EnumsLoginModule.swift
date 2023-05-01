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
}
enum StateModel {
    case initial
    case loading
    case success(AuthModel)
    case failure(error: AuthenticationError)
}
