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
        textField.toAutoLayout()
        textField.configureTextField(with: "Введите имя")
        textField.becomeFirstResponder()
        return textField
    }
    func makeLastNameTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.toAutoLayout()
        textField.configureTextField(with: "Введите фамилию", autocapitalizationType: .words)
        return textField
    }
    func makeGenderButton() -> UIButton {
        let genderButton = UIButton(type: .system)
        genderButton.toAutoLayout()
        genderButton.layer.cornerRadius = 10
        genderButton.layer.masksToBounds = true
        genderButton.tintColor = .systemBlue
        genderButton.showsMenuAsPrimaryAction = true
        genderButton.backgroundColor = .lightGray
        return genderButton
    }
    func makeMenu() -> UIMenu {
        let handler: UIActionHandler = { [weak self] action in
            self?.delegate?.updateGender(gender: action.title)
        }
        let man = UIAction(title: "Мужской", handler: handler)
        let woman = UIAction(title: "Женский", handler: handler)
        let notSet = UIAction(title: "Не установлен", image: UIImage (systemName: "person.fill.questionmark"), handler: handler)
        let menu = UIMenu(children: [man, woman, notSet])
        return menu
    }
    func makeDateOfBirthPicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.toAutoLayout()
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.datePickerMode = .date
        return datePicker
    }
    func makeDateOfBirthStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.toAutoLayout()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }
    func makeLogoImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.toAutoLayout()
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .createColor(lightMode: .white,
                                                 darkMode: .black)
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
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
        let label = CustomLabel(title: "Пол:")
        return label
    }
    func makeDateOfBirthLabel() -> CustomLabel {
        let label = CustomLabel(title: "Дата рождения:")
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
