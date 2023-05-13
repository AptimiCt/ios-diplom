//
//
// UITextField+Ext.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
extension UITextField {
    //Настройка textField
    func configureTextField(with placeholder: String,
                            borderWidth: CGFloat = 0.5,
                            cornerRadius: CGFloat = 10,
                            autocapitalizationType: UITextAutocapitalizationType = .none) {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .gray)
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.createColor(lightMode: .placeholderText, darkMode: .white)])
        self.textColor = .createColor(lightMode: .black, darkMode: .white)
        self.tintColor = UIColor(named: "AccentColor")
        self.font = .systemFont(ofSize: 16)
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.autocapitalizationType = autocapitalizationType
        self.toAutoLayout()
    }
}
