//
//
// AppError.swift
// Navigation
//
// Created by Александр Востриков
//
    

import Foundation

enum AppError: Error {
    case incorectLogicApp
    case unknown(String?)
}
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .incorectLogicApp:
                return "AppError.incorectLogicApp".localized
            case .unknown(let error):
                return "\("AppError.unknown".localized). \(error ?? "nil")"
            
        }
    }
}
