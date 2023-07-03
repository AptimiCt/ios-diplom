//
//
// EnumsLoginModule.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

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
    case success
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
        var profilePicture: UIImage?
    }
}

enum StateModelPost {
    case initial
//    case loading
    case success(PostData)
//    case failure(AuthenticationError)
    
    struct PostData {
        let uidUser: String
        var profilePicture: String
        var fullName: String
        var createdDate: String
        let uidPost: String
        var body: String
        var postImage: String?
        var likes: Int
        var isLiked: Bool
        var views:Int
    }
}
