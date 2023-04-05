//
//
// LocalAuthorizationService.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import LocalAuthentication

final class LocalAuthorizationService {
    
    enum BiometricError: LocalizedError {
        case authenticationFailed
        case userCancel
        case userFallback
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .authenticationFailed:
                    return "LocalAuthorizationService.authenticationFailed".localized
            case .userCancel:
                    return "LocalAuthorizationService.userCancel".localized
            case .userFallback:
                    return "LocalAuthorizationService.userFallback".localized
            case .biometryNotAvailable:
                    return "LocalAuthorizationService.biometryNotAvailable".localized
            case .biometryNotEnrolled:
                    return "LocalAuthorizationService.biometryNotEnrolled".localized
            case .biometryLockout:
                    return "LocalAuthorizationService.biometryLockout".localized
            case .unknown:
                    return "LocalAuthorizationService.unknown".localized
            }
        }
    }
        
    var biometricType: LABiometryType {
        evalutePolicy = context.canEvaluatePolicy(policyService, error: &error)
        if evalutePolicy {
            return context.biometryType
        }
        return .none
    }
    
    var evalutePolicy: Bool = false
    let context = LAContext()
    private let policyService: LAPolicy = .deviceOwnerAuthentication
    private var error: NSError?
    
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, BiometricError?) -> Void) {
        
        guard context.canEvaluatePolicy(policyService, error: &error) else {
            guard let error else { return authorizationFinished(false, nil) }
            authorizationFinished(false, biometricError(from: error))
            return
        }
        
        context.evaluatePolicy(policyService, localizedReason: "LocalAuthorizationService.localizedReason".localized) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    authorizationFinished(success, nil)
                } else {
                    guard let error else { return authorizationFinished(false, nil) }
                    authorizationFinished(success, self?.biometricError(from: error as NSError))
                }
            }
        }
        
    }
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        
        return error
    }
}
