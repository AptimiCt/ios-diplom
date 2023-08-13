//
//
// StateProfileView.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

enum StateProfileHeaderView {
    case initial
    case animate
    case success
    
    struct UserData {
        var name: String
        var surname: String
        var profilePicture: UIImage?
    }
}
