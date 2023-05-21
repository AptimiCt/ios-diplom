//
//
// UpdateInfoProfileView+Ext.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

extension UpdateInfoProfileView {
    func makeNameTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: "Введите имя")
        return textField
    }
    func makeLastNameTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: "Введите фамилию", autocapitalizationType: .words)
        return textField
    }
    func makeGenderTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: "Введите пол")
        return textField
    }
    func makeDateOfBirthTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: "Введите дату рождения")
        return textField
    }
    func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.toAutoLayout()
        return imageView
    }
    func makeNameLabel() -> CustomLabel {
        let label = CustomLabel(title: "Имя")
        return label
    }
    func makeSurnameLabel() -> CustomLabel {
        let label = CustomLabel(title: "Фамилия")
        return label
    }
    func makeGenderLabel() -> CustomLabel {
        let label = CustomLabel(title: "Пол")
        return label
    }
    func makeDateOfBirthLabel() -> CustomLabel {
        let label = CustomLabel(title: "Дата рождения")
        return label
    }
    func makeSignUpButton(screenType: ScreenType) -> CustomButton {
        let title: String
        switch screenType {
            case .new:
                title = "UIPV.tappedButton.new".localized
            case .update:
                title = "UIPV.tappedButton.update".localized
        }
        let button = CustomButton(
            title: title,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.configureButtons()
        return button
    }
    func makeActivityIndicatorView() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .createColor(lightMode: .black, darkMode: .white)
        activity.toAutoLayout()
        return activity
    }
}
