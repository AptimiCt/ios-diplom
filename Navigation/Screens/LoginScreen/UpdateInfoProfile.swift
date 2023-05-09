//
//
// UpdateInfoProfile.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class UpdateInfoProfile: UIViewController, UpdateInfoProfileProtocol {

    private lazy var nameTextField = makeNameTextField()
    private lazy var lastNameTextField = makeLastNameTextField()
    private lazy var genderTextField = makeGenderTextField()
    
    var viewModel: UpdateInfoProfileVidewModelProtocol
    
    init(viewModel: UpdateInfoProfileVidewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
    }
}

extension UpdateInfoProfile {
    func makeNameTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.layer.borderWidth = 0.5
        textField.configureTextField(with: "Введите имя")
        textField.toAutoLayout()
        return textField
    }
    func makeLastNameTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.layer.borderWidth = 0.5
        textField.configureTextField(with: "Введите фамилию")
        textField.toAutoLayout()
        return textField
    }
    func makeGenderTextField() -> TextFieldWithPadding {
        let textField = TextFieldWithPadding()
        textField.layer.borderWidth = 0.5
        textField.configureTextField(with: "Введите пол")
        textField.toAutoLayout()
        return textField
    }
}
private extension UpdateInfoProfile {
    func setupView() {
        view.addSubviews(nameTextField, lastNameTextField, genderTextField)
    }
    func setupConstraint() {
        
    }
}

