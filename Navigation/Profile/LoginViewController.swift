//
//  LoginViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 16.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - vars
    var delegate: LoginViewControllerDelegate?
    private var timer: Timer?
    private var count = 0
    
    private let scrollView = UIScrollView()
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
    
    private let loginTextView: UITextField = {
        let textField = UITextField()
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
    
    private let passwordTextView: UITextField = {
        let textField = UITextField()
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
    
    private let tabBarItemLocal = UITabBarItem(title: Constants.tabBarItemLoginVCTitle,
                                       image: UIImage(systemName: "person.crop.circle.fill"),
                                       tag: 1)
    
    //MARK: - init
    init(){
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = tabBarItemLocal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .createColor(lightMode: .white, darkMode: .systemGray3)
        setupView()
        setupConstrains()
        loginButtonTapped()
        signUpButtonTapped()
        choosePasswordButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - funcs
    private func setupView(){
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        logoImageView.toAutoLayout()
        stackView.toAutoLayout()
        loginButton.toAutoLayout()
        signUpButton.toAutoLayout()
        choosePasswordButton.toAutoLayout()
        passwordTextView.toAutoLayout()
        activityIndicator.toAutoLayout()
        
        view.addSubviews(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubviews(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        stackView.addArrangedSubview(loginTextView)
        stackView.addArrangedSubview(passwordTextView)
        contentView.addSubviews(logoImageView, stackView, loginButton, signUpButton, choosePasswordButton)
    }
    
    private func setupConstrains(){
        let constrains = [
            
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            
            choosePasswordButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            choosePasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            choosePasswordButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            choosePasswordButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            choosePasswordButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            
            activityIndicator.centerXAnchor.constraint(equalTo: passwordTextView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: passwordTextView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: passwordTextView.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(constrains)
    }
    
    //MARK: - @objc private funcs
    @objc
    private func keyboardWillShow(notification: NSNotification){
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        scrollView.contentInset.bottom = keyboardSize.height
        scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    @objc
    private func timerCrack(){
        count += 1
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.choosePasswordButton.setTitle(String(format: ~K.LoginVC.Keys.choosePasswordButtonSec.rawValue, self.count), for: .normal)
        }
    }
    
    //MARK: - private funcs
    private func checkCredentionalsOnError(email: String, password: String) throws {
        if email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            throw CredentialError.emptyEmail
        } else if !validate(email) {
            throw CredentialError.emailIsNoCorrect
        }
        if password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            throw CredentialError.emptyPassword
        }
        if !passwordIsValid(password) {
            throw CredentialError.incorrectCredentials
        }
    }
    
    private func handle(error: CredentialError) {
        switch error {
            case .incorrectCredentials:
                alertForError(message: ~error.rawValue)
            case .emptyEmail:
                alertForError(message: ~error.rawValue)
            case .emptyPassword:
                alertForError(message: ~error.rawValue)
            case .emailIsNoCorrect:
                alertForError(message: ~error.rawValue)
        }
    }
    
    private func alertForError(message: String) {
        let alert = UIAlertController(title: Constants.titleAlert, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: ~K.LoginVC.Keys.alertButtonActionOk.rawValue, style: .default)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func passwordIsValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    private func validate(_ email: String) -> Bool {
        let emailRegEx = "([a-z0-9.]){1,64}@([a-z0-9]){1,64}\\.([a-z0-9]){2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func loginButtonTapped() {
        loginButton.action = { [weak self] in
            guard let self = self else { return }
            guard let passwordText = self.passwordTextView.text, let loginText = self.loginTextView.text else { return }
            do {
                try self.checkCredentionalsOnError(email: loginText, password: passwordText)
                self.delegate?.checkCredentionalsInspector(email: loginText, password: passwordText, completion: { result in
                    #if DEBUG
                    let userService = TestUserService()
                    #else
                    let userService = CurrentUserService()
                    #endif
                    switch result {
                        case .success(let authModel):
                            let fullName = authModel.name
                            let profileViewController = ProfileViewController(loginName: fullName, userService: userService)
                            self.navigationController?.pushViewController(profileViewController, animated: true)
                        case .failure(let failure):
                            self.switchFailure(failure)
                    }
                })
            } catch {
                self.handle(error: error as! CredentialError)
            }
            
        }
    }
    private func switchFailure(_ failure: NSError) {
        switch failure.userInfo["FIRAuthErrorUserInfoNameKey"] as? String {
            case FirebaseResponseError.ERROR_INVALID_EMAIL.rawValue:
                self.alertForError(message: ~FirebaseResponseErrorMessage.invalidEmail.rawValue)
            case FirebaseResponseError.ERROR_USER_NOT_FOUND.rawValue:
                self.alertForError(message: ~FirebaseResponseErrorMessage.registerUser.rawValue)
            case FirebaseResponseError.ERROR_WRONG_PASSWORD.rawValue:
                self.alertForError(message: ~FirebaseResponseErrorMessage.wrongPassword.rawValue)
            case FirebaseResponseError.ERROR_NETWORK_REQUEST_FAILED.rawValue:
                self.alertForError(message: ~FirebaseResponseErrorMessage.internetConnectionProblem.rawValue)
            case FirebaseResponseError.ERROR_EMAIL_ALREADY_IN_USE.rawValue:
                self.alertForError(message: ~FirebaseResponseErrorMessage.theUserWithThisEmailAlreadyExists.rawValue)
            default:
                self.alertForError(message: ~FirebaseResponseErrorMessage.unknownError.rawValue)
        }
    }
    
    private func signUpButtonTapped() {
        signUpButton.action = { [weak self] in
            guard let self,
                  let passwordText = self.passwordTextView.text,
                  let loginText = self.loginTextView.text else { return }
            do {
                try self.checkCredentionalsOnError(email: loginText, password: passwordText)
                self.delegate?.signUpInspector(email: loginText, password: passwordText, completion: { result in
                    #if DEBUG
                    let userService = TestUserService()
                    #else
                    let userService = CurrentUserService()
                    #endif
                    switch result {
                        case .success(let authModel):
                            let fullName = authModel.name
                            let profileViewController = ProfileViewController(loginName: fullName, userService: userService)
                            self.navigationController?.pushViewController(profileViewController, animated: true)
                        case .failure(let failure):
                            self.switchFailure(failure)
                    }
                })
            } catch {
                self.handle(error: error as! CredentialError)
            }
        }
    }

    //Реализация bruteForce
    private func choosePasswordButtonTapped(){
        choosePasswordButton.action = { [weak self] in
            guard let self = self else { return }
            self.passwordTextView.delegate = self
            self.choosePasswordButton.setTitle("\(Constants.choosePassword)", for: .normal)
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCrack), userInfo: nil, repeats: true)
            let bruteForceManager = BruteForceManager()
            let passwordText = bruteForceManager.passwordGenerator(lengthPass: 3)
            self.activityIndicator.startAnimating()
            self.passwordTextView.isUserInteractionEnabled = false
            self.choosePasswordButton.isUserInteractionEnabled = false
            DispatchQueue.global().async {
                bruteForceManager.bruteForce(passwordToUnlock: passwordText)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.passwordTextView.isUserInteractionEnabled = true
                    self.choosePasswordButton.isUserInteractionEnabled = true
                    self.passwordTextView.isSecureTextEntry = false
                    self.passwordTextView.text = passwordText
                    self.timer?.invalidate()
                    self.count = 0
                    self.choosePasswordButton.setTitle("\(Constants.choosePassword)", for: .normal)
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !passwordTextView.isSecureTextEntry {
            passwordTextView.isSecureTextEntry.toggle()
        }
    }
}

extension LoginViewController {
    
}
