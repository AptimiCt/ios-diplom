//
//
// UIAlertController+Ext.swift
// Navigation
//
// Created by Александр Востриков
//

import UIKit
    
extension UIAlertController {
    convenience init(inputData: UIAlertControllerInputData) {
        self.init(title: inputData.title, message: inputData.message, preferredStyle: .alert)
        inputData.buttons
            .map { button in UIAlertAction(title: button.title, style: .default) { _ in button.action?() } }
            .forEach { self.addAction($0) }
    }
}
