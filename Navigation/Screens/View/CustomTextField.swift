//
//  CustomTextField.swift
//  Navigation
//
//  Created by Александр Востриков on 17.06.2022.
//

import UIKit

final class CustomTextField: TextFieldWithPadding {
    
    init(font: UIFont, placeholder: String) {
        super.init(frame: .zero)
        self.font = font
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
