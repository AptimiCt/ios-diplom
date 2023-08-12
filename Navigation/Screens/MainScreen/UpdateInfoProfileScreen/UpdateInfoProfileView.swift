//
//
// UpdateInfoProfileView.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

class UpdateInfoProfileView: UIView {
    //MARK: - property
    weak var delegate: UpdateInfoProfileViewDelegate?
    
    var stateView: StateModelProfile = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    private var screenType: ScreenType
    
    //MARK: - UIView and UIControl
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var activityIndicator = makeActivityIndicatorView()
    private lazy var nameLabel = makeNameLabel()
    private lazy var nameTextField = makeNameTextField()
    private lazy var surnameLabel = makeSurnameLabel()
    private lazy var surnameTextField = makeLastNameTextField()
    private lazy var genderLabel = makeGenderLabel()
    private lazy var genderButton = makeGenderButton()
    private lazy var dateOfBirthLabel = makeDateOfBirthLabel()
    private lazy var datePickerView = makeDateOfBirthPicker()
    lazy var profilePictureImageView = makeLogoImageView()
    private lazy var signUpButton = makeSignUpButton(screenType: screenType)
    private lazy var dateOfBirthStackView = makeDateOfBirthStackView()
    private lazy var genderStackView = makeDateOfBirthStackView()
    
    //MARK: - init
    init(screenType: ScreenType) {
        self.screenType = screenType
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
                  let genderText = self.genderButton.titleLabel?.text,
                  let profilePictureImageView = self.profilePictureImageView.image
            else { return }
            self.delegate?.updateName(name: nameText)
            self.delegate?.updateSurname(surname: surnameText)
            self.delegate?.updateGender(gender: genderText)
            self.delegate?.updateDateOfBirth(dateOfBirth: self.datePickerView.date)
            self.delegate?.updateProfilePicture(image: profilePictureImageView)
            switch screenType {
                case .new:
                    self.delegate?.addUser()
                case .update:
                    self.delegate?.updateUser()
            }
        }
    }
    func update(userData: StateModelProfile.UserData?) {
        guard let userData else { return }
        nameTextField.text = userData.name
        surnameTextField.text = userData.surname
        genderButton.setTitle(userData.gender, for: .normal)
        datePickerView.setDate(userData.dateOfBirth, animated: true)
        profilePictureImageView.image = userData.profilePicture
    }
    
    //Добавление и настройка view
    func setupView(){
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        genderButton.menu = makeMenu()
        datePickerView.addTarget (self, action: #selector (dateChanged), for: .valueChanged)
        
        let choicePhoto = UITapGestureRecognizer(target: self, action: #selector(choicePhoto))
        choicePhoto.numberOfTapsRequired = 1
        profilePictureImageView.addGestureRecognizer(choicePhoto)
        profilePictureImageView.isUserInteractionEnabled = true
        
        scrollView.toAutoLayout()
        contentView.toAutoLayout()
        self.addSubviews(scrollView, activityIndicator)
        scrollView.addSubview(contentView)
        scrollView.keyboardDismissMode = .interactive
        
        dateOfBirthStackView.addArrangedSubview(dateOfBirthLabel)
        dateOfBirthStackView.addArrangedSubview(datePickerView)
        
        genderStackView.addArrangedSubview(genderLabel)
        genderStackView.addArrangedSubview(genderButton)
        
        contentView.addSubviews(
            profilePictureImageView,
            nameLabel,
            nameTextField,
            surnameLabel,
            surnameTextField,
            genderStackView,
            dateOfBirthStackView,
            signUpButton
        )
        genderButton.widthAnchor.constraint(equalTo: datePickerView.widthAnchor).isActive = true
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
            
            genderStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genderStackView.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 16),
            genderStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateOfBirthStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateOfBirthStackView.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 16),
            dateOfBirthStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            signUpButton.topAnchor.constraint(equalTo: dateOfBirthStackView.bottomAnchor, constant: 28),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: Constants.heightForLoginButton),
            signUpButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constrains)
    }
}
//MARK: - @objc private extension UpdateInfoProfileView
@objc private extension UpdateInfoProfileView {
    func dateChanged() {
        delegate?.updateDateOfBirth(dateOfBirth: datePickerView.date)
    }
    func  choicePhoto() {
        delegate?.choicePhoto()
    }
}
//MARK: - extension UpdateInfoProfileView: UITextFieldDelegate
extension UpdateInfoProfileView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else { return true }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        switch textField {
            case nameTextField:
                delegate?.updateName(name: updatedText.trimmingCharacters(in: .whitespaces))
            case surnameTextField:
                delegate?.updateSurname(surname: updatedText.trimmingCharacters(in: .whitespaces))
            default:
                print("new textField:\(textField)")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case nameTextField:
                surnameTextField.becomeFirstResponder()
            case surnameTextField:
                nameTextField.becomeFirstResponder()
            default:
                print("new textField:\(textField)")
        }
        return true
    }
}
