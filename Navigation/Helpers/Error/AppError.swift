//
//
// AppError.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

enum AppError: Error {
    case incorrectLogicApp
    case unknown(String?)
}
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .incorrectLogicApp:
                return "AppError.incorrectLogicApp".localized
            case .unknown(let error):
                return "\("AppError.unknown".localized). \(error ?? "nil")"
            
        }
    }
}
