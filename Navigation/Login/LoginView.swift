//
//
// LoginView.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import LocalAuthentication

class LoginView: UIView {
    
    private var biometricType: LABiometryType
    
    private lazy var scrollView = UIScrollView()
    private let contentView = UIView()
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .createColor(lightMode: .black, darkMode: .white)
        return activity
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()
    
    private let loginTextView: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .gray)
        textField.attributedPlaceholder = NSAttributedString(string: Constants.loginTextViewPlaceholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.createColor(lightMode: .placeholderText, darkMode: .white)])
        textField.textColor = .createColor(lightMode: .black, darkMode: .white)
        textField.tintColor = UIColor(named: "AccentColor")
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextView: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .gray)
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: Constants.passwordTextViewPlaceholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.createColor(lightMode: .placeholderText, darkMode: .white)])
        textField.textColor = .createColor(lightMode: .black, darkMode: .white)
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(
            title: Constants.logIn,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private let signUpButton: CustomButton = {
        let button = CustomButton(
            title: Constants.signUp,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private let choosePasswordButton: CustomButton = {
        let button = CustomButton(
            title: Constants.choosePassword,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    private lazy var loginWithBiometrics: CustomButton = {
        let button = CustomButton(
            title: Constants.logInWithBiometrics,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.setImage(switchImage(for: biometricType), for: .normal)
        button.tintColor = .createColor(lightMode: .white,
                                        darkMode: .black)
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        if biometricType == .none {
            button.isEnabled = false
        }
        return button
    }()
    
    init(biometricType: LABiometryType) {
        self.biometricType = biometricType
        super.init(frame: .zero)
        setupView()
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        setupConstrains()
    }
}
extension LoginView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !passwordTextView.isSecureTextEntry {
            passwordTextView.isSecureTextEntry.toggle()
        }
    }
}

extension LoginView {
    private func switchImage(for biometricType: LABiometryType) -> UIImage? {
        switch biometricType {
            case .none:
                return nil
            case .touchID:
                return UIImage(systemName: "touchid")
            case .faceID:
                return UIImage(systemName: "faceid")
            @unknown default:
                return UIImage(systemName: "questionmark")
        }
    }
    
    private func setupView(){
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        logoImageView.toAutoLayout()
        stackView.toAutoLayout()
        loginButton.toAutoLayout()
        signUpButton.toAutoLayout()
        loginWithBiometrics.toAutoLayout()
        choosePasswordButton.toAutoLayout()
        passwordTextView.toAutoLayout()
        activityIndicator.toAutoLayout()
        
        self.addSubviews(scrollView, activityIndicator)
        scrollView.addSubviews(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        stackView.addArrangedSubview(loginTextView)
        stackView.addArrangedSubview(passwordTextView)
        contentView.addSubviews(logoImageView, stackView, loginButton, signUpButton, loginWithBiometrics, choosePasswordButton)
    }
    private func setupConstrains(){
        let constrains = [
            
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                                               constant: Constants.topMarginForLogoImageView),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.heightForLogoImageView),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.widthForLogoImageView),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.leadingMarginForStackView),
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                           constant: Constants.topMarginForStackView),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: Constants.trailingMarginForStackView),
            stackView.heightAnchor.constraint(equalToConstant: Constants.heightForStackView),
            
            loginTextView.heightAnchor.constraint(equalToConstant: Constants.heightForStackView / 2),
            passwordTextView.heightAnchor.constraint(equalToConstant: Constants.heightForStackView / 2),
            
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,
                                             constant: Constants.topMarginForLoginButton),
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            
            signUpButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            
            loginWithBiometrics.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            loginWithBiometrics.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            loginWithBiometrics.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            loginWithBiometrics.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            
            choosePasswordButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            choosePasswordButton.topAnchor.constraint(equalTo: loginWithBiometrics.bottomAnchor, constant: 16),
            choosePasswordButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            choosePasswordButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            choosePasswordButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            
            activityIndicator.centerXAnchor.constraint(equalTo: passwordTextView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: passwordTextView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: passwordTextView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}
