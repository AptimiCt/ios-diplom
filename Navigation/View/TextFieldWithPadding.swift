//
//  TextFieldWithPadding.swift
//  Navigation
//
//  Created by Александр Востриков on 07.01.2023.
//

import UIKit

class TextFieldWithPadding: UITextField {
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
}
