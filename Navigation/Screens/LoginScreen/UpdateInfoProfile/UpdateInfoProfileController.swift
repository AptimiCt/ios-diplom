//
//
// UpdateInfoProfileController.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class UpdateInfoProfileController: UIViewController, UpdateInfoProfileProtocol {
    
    //MARK: - property
    var viewModel: UpdateInfoProfileVidewModelProtocol
    var updateInfoProfileView: UpdateInfoProfileView
    //MARK: - init
    init(viewModel: UpdateInfoProfileVidewModelProtocol) {
        self.viewModel = viewModel
        self.updateInfoProfileView = UpdateInfoProfileView()
        super.init(nibName: nil, bundle: nil)
        self.updateInfoProfileView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - override funcs
    override func loadView() {
        view = updateInfoProfileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchStateViewModel()
        viewModel.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Реакция на появление и скрытие клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
//MARK: - private funcs in extension
private extension UpdateInfoProfileController {
    func switchStateViewModel() {
        viewModel.stateChanged = { [weak self] stateView in
            guard let self else { return }
            self.updateInfoProfileView.stateView = stateView
        }
    }
}
extension UpdateInfoProfileController: UpdateInfoProfileViewDelegate {
    
    func updateName(name: String) {
        viewModel.updateName(name)
    }
    
    func updateSurname(surname: String) {
        viewModel.updateSurname(surname)
    }
    
    func updateGender(gender: String) {
        viewModel.updateGender(gender)
    }
    
    func updateDateOfBirth(dateOfBirth: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: dateOfBirth)
        guard let date else { return }
        viewModel.updateDateOfBirth(date)
    }
    
    func updateProfilePicture(image: UIImage) {
        viewModel.updateProfilePicture("avatar")
    }
    func updateUser() {
        viewModel.updateUser()
        dismiss(animated: true)
    }
}
//MARK: - @objc private funcs in extension
@objc private extension UpdateInfoProfileController {
    //Метод выполняются когда появляется клавиатура
    func keyboardWillShow(notification: NSNotification){
        //updateInfoProfileView.keyboardWillShow(notification: notification)
        self.updateInfoProfileView.stateView = .keyboardWillShow(notification)
    }
    //Метод выполняются когда скрывается клавиатура
    func keyboardWillHide(notification: NSNotification){
        self.updateInfoProfileView.stateView = .keyboardWillHide(notification)
        //updateInfoProfileView.keyboardWillHide(notification: notification)
    }
}

