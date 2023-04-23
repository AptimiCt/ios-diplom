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
    
    weak var delegate: LoginViewDelegate?
    private var biometricType: LABiometryType
    private var buttonTapped: ButtonsTapped = .undefined
    
    var stateView: StateView = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    
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
        textField.configureTextField(with: Constants.loginTextViewPlaceholder)
        return textField
    }()
    private let passwordTextView: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.configureTextField(with: Constants.passwordTextViewPlaceholder)
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
        button.configureButtons()
        return button
    }()
    private let signUpButton: CustomButton = {
        let button = CustomButton(
            title: Constants.signUp,
            titleColor: .createColor(lightMode: .white,
                                     darkMode: .black)
        )
        button.configureButtons()
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
        button.configureButtons()
        if biometricType == .none {
            button.isEnabled = false
        }
        return button
    }()
    
    //MARK: - init
    init(biometricType: LABiometryType) {
        self.biometricType = biometricType
        super.init(frame: .zero)
        setupView()
        buttonsAction(with: loginButton)
        buttonsAction(with: signUpButton)
        loginWithBiometricsButtonTapped()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override func
    override func layoutSubviews() {
        super.layoutSubviews()
        switch stateView {
            case .initial:
                print("Пройдите регистрацию")
            case .loading:
                activityIndicatorOn()
            case .success:
                activityIndicatorOff(with: buttonTapped)
            case .failure:
                activityIndicatorOff(with: buttonTapped)
        }
        setupConstrains()
    }
}
//MARK: - extension LoginView
extension LoginView {
    //Обрабока появление клавиатуры
    func keyboardWillShow(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset.bottom = keyboardSize.height
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    //Обрабока скрытия клавиатуры
    func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    func activityIndicatorOff(with button: ButtonsTapped) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        switch button {
            case .login:
                loginButton.isEnabled = true
            case .registration:
                signUpButton.isEnabled = true
            case .undefined:
                print("Кнопка не нажата")
                break
        }
    }
    func activityIndicatorOn() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
}
//MARK: - private extension LoginView
private extension LoginView {
    //Метод реакции на нажатие на кнопки вход и регистрация
    func buttonsAction(with button: CustomButton) {
        button.action = { [weak self] in
            guard let self,
                  let passwordText = self.passwordTextView.text,
                  let loginText = self.loginTextView.text
            else { return }
            button.isEnabled = false
            self.switchDelegateMethod(button: button, email: loginText, password: passwordText)
        }
    }
    func loginWithBiometricsButtonTapped(){
        loginWithBiometrics.action = { [weak self] in
            #warning("loginWithBiometrics")
            //self?.delegate?.loginWithBiometrics()
        }
    }
    //Выбор метода делегата для вызова в зависимости от нажатой кнопки
    func switchDelegateMethod(button: CustomButton, email: String, password: String) {
        activityIndicatorOn()
        switch button {
            case loginButton:
                buttonTapped = .login
                self.delegate?.login(email: email, password: password)
            case signUpButton:
                buttonTapped = .registration
                self.delegate?.signUp(email: email, password: password)
            default:
                button.isEnabled = true
        }
    }
    //Установка иконки доступной на устройстве типа биометрии
    func switchImage(for biometricType: LABiometryType) -> UIImage? {
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
    //Добавление и настройка view
    func setupView(){
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        logoImageView.toAutoLayout()
        stackView.toAutoLayout()
        loginButton.toAutoLayout()
        signUpButton.toAutoLayout()
        loginWithBiometrics.toAutoLayout()
        passwordTextView.toAutoLayout()
        activityIndicator.toAutoLayout()
        
        self.addSubviews(scrollView, activityIndicator)
        scrollView.addSubviews(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        stackView.addArrangedSubview(loginTextView)
        stackView.addArrangedSubview(passwordTextView)
        contentView.addSubviews(logoImageView, stackView, loginButton, signUpButton, loginWithBiometrics)
        
        self.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
    }
    //Установка констраинтов
    func setupConstrains(){
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
            loginWithBiometrics.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}
//MARK: - fileprivate extension UITextField
fileprivate extension UITextField {
    //Настройка textField
    func configureTextField(with placeholder: String) {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .createColor(lightMode: .systemGray6, darkMode: .gray)
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.createColor(lightMode: .placeholderText, darkMode: .white)])
        self.textColor = .createColor(lightMode: .black, darkMode: .white)
        self.tintColor = UIColor(named: "AccentColor")
        self.font = .systemFont(ofSize: 16)
        self.autocapitalizationType = .none
    }
}
//MARK: - fileprivate extension UIButton
fileprivate extension UIButton {
    func configureButtons() {
        self.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
