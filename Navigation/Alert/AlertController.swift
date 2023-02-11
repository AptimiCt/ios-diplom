//
//
// AlertController.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class AlertController {
    
    static let defaultController = AlertController()
    let actionOk = UIAlertAction(title: ~K.LoginVC.Keys.alertButtonActionOk.rawValue, style: .default)

    func showAlert(in controller: UIViewController,
                   title: String = Constants.titleAlert,
                   message: String
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(actionOk)
        controller.present(alertController, animated: true)
    }
}
