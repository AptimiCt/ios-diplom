//
//
// LaunchInstructor.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

enum LaunchInstructor {
    case auth, main
    
    static func configure(isAutorized: Bool = false) -> LaunchInstructor {
        switch isAutorized {
            case true:
                return .main
            case false:
                return .auth
        }
    }
}
