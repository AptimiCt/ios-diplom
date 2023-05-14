//
//
// UIAlertControllerInputData.swift
// Navigation
//
// Created by Александр Востриков
//

struct UIAlertControllerInputData {
    let title: String?
    let message: String?
    let buttons: [Button]
    
    init(title: String? = Constants.titleAlert, message: String? = nil, buttons: [Self.Button]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

extension UIAlertControllerInputData {
    struct Button {
        let title: String
        let action: VoidClosure?
        
        init(title: String, action: VoidClosure? = nil) {
            self.title = title
            self.action = action
        }
    }
}
