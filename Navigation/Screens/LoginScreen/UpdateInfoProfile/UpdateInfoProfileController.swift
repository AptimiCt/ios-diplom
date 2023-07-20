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
    private var screenType: ScreenType
    var viewModel: UpdateInfoProfileVidewModelProtocol
    var updateInfoProfileView: UpdateInfoProfileView
    //MARK: - init
    init(viewModel: UpdateInfoProfileVidewModelProtocol, screenType: ScreenType) {
        self.screenType = screenType
        self.viewModel = viewModel
        self.updateInfoProfileView = UpdateInfoProfileView(screenType: screenType)
        super.init(nibName: nil, bundle: nil)
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
        self.updateInfoProfileView.delegate = self
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
    deinit {
        print("UpdateInfoProfileController удален")
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
    
    func updateDateOfBirth(dateOfBirth: Date) {
        viewModel.updateDateOfBirth(dateOfBirth)
    }
    
    func updateProfilePicture(image: UIImage) {
        viewModel.updateProfilePicture(image)
    }
    func addUser() {
        viewModel.addUser()
        dismiss(animated: true)
    }
    func updateUser() {
        viewModel.updateUser()
        dismiss(animated: true)
    }
    func choicePhoto() {
        presentPhotoActionSheet()
    }
}
//MARK: - @objc private funcs in extension
@objc private extension UpdateInfoProfileController {
    //Метод выполняются когда появляется клавиатура
    func keyboardWillShow(notification: NSNotification){
        self.updateInfoProfileView.stateView = .keyboardWillShow(notification)
    }
    //Метод выполняются когда скрывается клавиатура
    func keyboardWillHide(notification: NSNotification){
        self.updateInfoProfileView.stateView = .keyboardWillHide(notification)
    }
}
extension UpdateInfoProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile photo",
                                            message: "Как вы хотите выбрать фото?",
                                            preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let camera = UIAlertAction(title: "camera", style: .default) { [weak self] _ in
            self?.presentCamera()
        }
        let photoLibrary = UIAlertAction(title: "photoLibrary", style: .default) { [weak self] _ in
            self?.presentPhotoPicker()
        }
        actionSheet.addAction(cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photoLibrary)
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    func presentPhotoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        viewModel.updateProfilePicture(image)
    }
}

