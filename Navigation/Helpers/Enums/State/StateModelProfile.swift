//
//
// StateModelProfile.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

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
