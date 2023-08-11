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
    private var buttonTapped: ButtonsTapped = .undefined
    
    var stateView: StateView = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var activityIndicator = makeActivityIndicatorView()
    private lazy var logoImageView = makeLogoImageView()
    private lazy var loginTextView = makeLoginTextView()
    private lazy var passwordTextView = makePasswordTextView()
    private lazy var stackView = makeStackView()
    private lazy var loginButton = makeLoginButton()
    private lazy var signUpButton = makeSignUpButton()
    
    //MARK: - init
    init() {
        super.init(frame: .zero)
        setupView()
        buttonsAction(with: loginButton)
        buttonsAction(with: signUpButton)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override func
    override func layoutSubviews() {
        super.layoutSubviews()
        switch stateView {
            case .initial:
                break
            case .loading:
                activityIndicatorOn()
            case .success:
                activityIndicatorOff(with: buttonTapped)
            case .failure:
                activityIndicatorOff(with: buttonTapped)
            case .keyboardWillShow(_):
                break
            case .keyboardWillHide(_):
                break
        }
        setupConstrains()
    }
}
//MARK: - extension LoginView
extension LoginView {
    //Обработка появление клавиатуры
    func keyboardWillShow(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset.bottom = keyboardSize.height
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    //Обработка скрытия клавиатуры
    func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
}
//MARK: - private extension LoginView
private extension LoginView {
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
    
    //Добавление и настройка view
    func setupView(){
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        
        self.addSubviews(scrollView, activityIndicator)
        scrollView.addSubviews(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        stackView.addArrangedSubview(loginTextView)
        stackView.addArrangedSubview(passwordTextView)
        contentView.addSubviews(logoImageView, stackView, loginButton, signUpButton)
        
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
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}
