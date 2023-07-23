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
        Logger.standart.start(on: self)
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
        switchStateViewModel()
        viewModel.setupView()
        setupDelegate()
        if screenType == .new {
            isModalInPresentation = true
        }
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
        Logger.standart.remove(on: self)
    }
}
//MARK: - private funcs in extension
private extension UpdateInfoProfileController {
    func setupDelegate() {
        self.updateInfoProfileView.delegate = self
        self.presentationController?.delegate = self
    }
    func switchStateViewModel() {
        viewModel.stateChanged = { [weak self] stateView in
            guard let self else { return }
            self.updateInfoProfileView.stateView = stateView
        }
    }
    func saveAndExit() {
        screenType == .new ? addUser() : updateUser()
    }
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(
            title: "UIP.actionSheet.title".localized,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let camera = UIAlertAction(title: "UIP.actionSheetCamera.title".localized, style: .default) { [weak self] _ in
            self?.presentCamera()
        }
        let photoLibrary = UIAlertAction(title: "UIP.actionSheetPhotoLibrary.title".localized, style: .default) { [weak self] _ in
            self?.presentPhotoPicker()
        }
        let cancel = UIAlertAction(title: "UIAC.cancel".localized, style: .cancel)
        
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

    func showAlertSheet(with title: AlertSheetForExit) {
        
        let alertSheet = UIAlertController(
            title: title.alertSheetTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let saveAction = UIAlertAction(title: title.saveActionTitle, style: .default) { [weak self] _ in
            self?.saveAndExit()
        }
        let unSaveAction = UIAlertAction(title: title.unSaveActionTitle, style: .destructive) { [weak self] _ in
            self?.viewModel.exit(with: nil)
        }
        let cancelAction = UIAlertAction(title: title.cancelActionTitle, style: .cancel)
        
        alertSheet.addAction(saveAction)
        alertSheet.addAction(unSaveAction)
        alertSheet.addAction(cancelAction)
        
        present(alertSheet, animated: true)
    }
    func titleForActionSheet() -> AlertSheetForExit {
        let alertSheetTitle = "UIPC.alertSheetTitle".localized
        let saveActionTitle = "UIPC.saveActionTitle.\(screenType)".localized
        let unSaveActionTitle = "UIPC.unSaveActionTitle.\(screenType)".localized
        let cancelActionTitle = "UIAC.cancel".localized
        
        return AlertSheetForExit(alertSheetTitle: alertSheetTitle, saveActionTitle: saveActionTitle, unSaveActionTitle: unSaveActionTitle, cancelActionTitle: cancelActionTitle)
    }
    struct AlertSheetForExit {
        let alertSheetTitle: String
        let saveActionTitle: String
        let unSaveActionTitle: String
        let cancelActionTitle: String
    }
}
extension UpdateInfoProfileController: UpdateInfoProfileViewDelegate {
    
    func updateName(name: String) {
        isModalInPresentation = true
        viewModel.updateName(name)
    }
    
    func updateSurname(surname: String) {
        isModalInPresentation = true
        viewModel.updateSurname(surname)
    }
    
    func updateGender(gender: String) {
        isModalInPresentation = true
        viewModel.updateGender(gender)
    }
    
    func updateDateOfBirth(dateOfBirth: Date) {
        isModalInPresentation = true
        viewModel.updateDateOfBirth(dateOfBirth)
    }
    
    func updateProfilePicture(image: UIImage) {
        isModalInPresentation = true
        viewModel.updateProfilePicture(image)
    }
    func addUser() {
        viewModel.addUser()
    }
    func updateUser() {
        viewModel.updateUser()
    }
    func choicePhoto() {
        isModalInPresentation = true
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        viewModel.updateProfilePicture(image)
    }
}
extension UpdateInfoProfileController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.exit(with: nil)
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showAlertSheet(with: titleForActionSheet())
    }
}
