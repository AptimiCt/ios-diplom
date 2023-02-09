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
    var evalutePolicy: Bool = false
    let context = LAContext()
    private let policyService: LAPolicy = .deviceOwnerAuthentication
    private var error: NSError?
    
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        
        let evalutePolicy = context.canEvaluatePolicy(policyService, error: &error)
        
        if evalutePolicy {
            alertForError(message: "Система биометрии не настроена или выключена")
            return
        }
        
        context.evaluatePolicy(policyService, localizedReason: "Доступ в приложение вк") { [weak self] success, error in
            guard let self else { return }
            DispatchQueue.main.async {
                if success {
                    authorizationFinished(success)
                } else {
                    authorizationFinished(success)
                    guard let error else { return }
                    self.alertForError(message: error.localizedDescription)
                }
            }
        }
        
        
    }
    private func alertForError(message: String) {
        let alert = UIAlertController(title: Constants.titleAlert, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: ~K.LoginVC.Keys.alertButtonActionOk.rawValue, style: .default)
        alert.addAction(actionOk)
        //present(alert, animated: true, completion: nil)
    }
    
}
