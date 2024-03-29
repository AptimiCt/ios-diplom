//
//
// LoginView+Ext.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit
import LocalAuthentication

extension LoginView {
    func makeLoginTextView() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: Constants.loginTextViewPlaceholder,
                                     cornerRadius: 0)
        return textField
    }
    func makePasswordTextView() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: Constants.passwordTextViewPlaceholder,
                                     borderWidth: 0,
                                     cornerRadius: 0)
        textField.isSecureTextEntry = true
        return textField
    }
    
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .createColor(lightMode: .black, darkMode: .white)
        activity.toAutoLayout()
        return activity
    }
    func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.toAutoLayout()
        return imageView
    }
    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.toAutoLayout()
        stackView.axis = .vertical
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        return stackView
    }
    func makeLoginButton() -> CustomButton {
        let button = CustomButton(
            title: Constants.logIn,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.configureButtons()
        return button
    }
    func makeSignUpButton() -> CustomButton {
        let button = CustomButton(
            title: Constants.signUp,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.configureButtons()
        return button
    }
}
