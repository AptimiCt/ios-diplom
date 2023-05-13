//
//
// UpdateInfoProfileView.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

class UpdateInfoProfileView: UIView {
    
    weak var delegate: UpdateInfoProfileViewDelegate?
    
    var stateView: StateModelProfile = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var activityIndicator = makeActivityIndicatorView()
    private lazy var nameLabel = makeNameLabel()
    private lazy var nameTextField = makeNameTextField()
    private lazy var surnameLabel = makeSurnameLabel()
    private lazy var surnameTextField = makeLastNameTextField()
    private lazy var genderLabel = makeGenderLabel()
    private lazy var genderTextField = makeGenderTextField()
    private lazy var dateOfBirthLabel = makeDateOfBirthLabel()
    private lazy var dateOfBirthTextField = makeDateOfBirthTextField()
    private lazy var profilePictureImageView = makeLogoImageView()
    private lazy var signUpButton = makeSignUpButton()
    
    //MARK: - init
    init() {
        super.init(frame: .zero)
        setupView()
        buttonsAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override func
    override func layoutSubviews() {
        super.layoutSubviews()
        switch stateView {
            case .initial:
                activityIndicatorOn()
            case .loading:
                activityIndicatorOn()
            case .success(let userData):
                activityIndicatorOff()
                update(userData: userData)
            case .failure:
                activityIndicatorOff()
            case .keyboardWillShow(let notification):
                keyboardWillShow(notification: notification)
            case .keyboardWillHide(let notification):
                keyboardWillHide(notification: notification)
        }
        setupConstrains()
    }
}

//MARK: - private extension UpdateInfoProfileView
private extension UpdateInfoProfileView {
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
    func activityIndicatorOff() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        signUpButton.isEnabled = true
    }
    func activityIndicatorOn() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    //Метод реакции на нажатие на кнопки вход и регистрация
    func buttonsAction() {
        signUpButton.action = { [weak self] in
            guard let self,
                  let nameText = self.nameTextField.text,
                  let surnameText = self.surnameTextField.text,
                  let genderText = self.genderTextField.text,
                  let dateOfBirth = self.dateOfBirthTextField.text,
                  let profilePictureImageView = self.profilePictureImageView.image
            else { return }
            //signUpButton.isEnabled = true
            //            self.switchDelegateMethod(button: button, email: loginText, password: passwordText)
            self.delegate?.updateName(name: nameText)
            self.delegate?.updateSurname(surname: surnameText)
            self.delegate?.updateGender(gender: genderText)
            self.delegate?.updateDateOfBirth(dateOfBirth: dateOfBirth)
            self.delegate?.updateProfilePicture(image: profilePictureImageView)
            self.delegate?.updateUser()
        }
    }
    //Выбор метода делегата для вызова в зависимости от нажатой кнопки
    //    func switchDelegateMethod(button: CustomButton, email: String, password: String) {
    //        activityIndicatorOn()
    //        switch button {
    //            case loginButton:
    //                buttonTapped = .login
    //                self.delegate?.login(email: email, password: password)
    //            case signUpButton:
    //                buttonTapped = .registration
    //                self.delegate?.signUp(email: email, password: password)
    //            case loginWithBiometrics:
    //                buttonTapped = .loginWithBiometrics
    //                self.delegate?.loginWithBiometrics()
    //            default:
    //                button.isEnabled = true
    //        }
    //    }
    func update(userData: StateModelProfile.UserData?) {
        nameTextField.text = userData?.name
        surnameTextField.text = userData?.surname
        genderTextField.text = userData?.gender
        if #available(iOS 15.0, *) {
            dateOfBirthTextField.text = userData?.dateOfBirth.formatted()
        } else {
            dateOfBirthTextField.text = userData?.dateOfBirth.description
        }
        profilePictureImageView.image = UIImage(named: userData?.profilePicture ?? "defaultProfilePicture")
    }
    //Добавление и настройка view
    func setupView(){
        
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        
        self.addSubviews(scrollView, activityIndicator)
        scrollView.addSubview(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        contentView.addSubviews(
            profilePictureImageView,
            nameLabel,
            nameTextField,
            surnameLabel,
            surnameTextField,
            genderLabel,
            genderTextField,
            dateOfBirthLabel,
            dateOfBirthTextField,
            signUpButton
        )
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
            
            profilePictureImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: Constants.leadingMarginForStackView),
            profilePictureImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profilePictureImageView.widthAnchor.constraint(equalToConstant: Constants.heightForLogoImageView),
            profilePictureImageView.heightAnchor.constraint(equalToConstant: Constants.heightForLogoImageView),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            surnameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            surnameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            surnameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            surnameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            surnameTextField.topAnchor.constraint(equalTo: surnameLabel.bottomAnchor, constant: 8),
            surnameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            genderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genderLabel.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 16),
            genderLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            genderTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genderTextField.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            genderTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            genderTextField.heightAnchor.constraint(equalToConstant: 40),
            
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateOfBirthLabel.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 16),
            dateOfBirthLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateOfBirthTextField.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 8),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 40),
            
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 28),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}
