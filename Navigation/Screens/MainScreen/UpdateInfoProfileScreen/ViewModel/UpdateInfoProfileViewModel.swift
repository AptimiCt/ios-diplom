//
//
// UpdateInfoProfileViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import SDWebImage

final class UpdateInfoProfileViewModel: UpdateInfoProfileViewModelProtocol {
    
    weak var coordinator: UpdateInfoProfileCoordinator?
    private let userService: UserService
    private let firestore: DatabeseManagerProtocol
    private let defaultProfilePicture = UIImage(named: Constants.defaultProfilePicture)
    
    var stateChanged: ((StateModelProfile) -> Void)?
    
    var viewData: StateModelProfile.UserData {
        StateModelProfile.UserData(name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth, profilePicture: profilePicture)
    }
    
    private var name: String = ""
    private var surname: String = ""
    private var gender: String = "UIPVM.gender.unselected".localized
    private var dateOfBirth: Date = Date()
    private lazy var profilePicture: UIImage? = defaultProfilePicture
    
    init(userService: UserService, firestore: DatabeseManagerProtocol) {
        self.userService = userService
        self.firestore = firestore
        self.configureProperty()
        Logger.standard.start(on: self)
    }
    
    func updateUser() {
        guard let profilePicture else { return }
        let filename = userService.getUser().profilePictureFilename
        uploadImage(image: profilePicture, fileName: filename) { [weak self] result in
            switch result {
                case .success(let url):
                    self?.updateUserFromProperty(with: url)
                case .failure(let error):
                    self?.updateUserFromProperty(with: nil)
                    print("error uploadImage:\(error)")
            }
            guard let self else { self?.exit(with: AppError.incorrectLogicApp); return }
            let user = self.userService.getUser()
            self.firestore.updateUser(user: user) { error in
                if let error {
                    self.exit(with: error)
                }
            }
            exit(with: nil)
        }
    }
    func addUser() {
        guard let profilePicture else { return }
        let filename = userService.getUser().profilePictureFilename
        uploadImage(image: profilePicture, fileName: filename) { [weak self] result in
            guard let self else { self?.exit(with: AppError.incorrectLogicApp); return }
            switch result {
                case .success(let url):
                    self.updateUserFromProperty(with: url)
                    let user = self.userService.getUser()
                    self.firestore.addUser(user: user) {  error in
                        if let error {
                            self.exit(with: error)
                        }
                        self.exit(with: nil)
                    }
                case .failure(let error):
                    print("error uploadImage:\(error)")
                    self.exit(with: error)
            }
        }
    }
    func exit(with error: Error?) {
        let user = self.userService.getUser()
        coordinator?.finishFlow?(user, error)
    }
    func updateName(_ name: String) {
        self.name = name
        setupView()
    }
    
    func updateSurname(_ surname: String) {
        self.surname = surname
        setupView()
    }
    
    func updateGender(_ gender: String) {
        self.gender = gender
        setupView()
    }
    
    func updateDateOfBirth(_ dateOfBirth: Date) {
        self.dateOfBirth = dateOfBirth
        setupView()
    }
    
    func updateProfilePicture(_ profilePicture: UIImage) {
        self.profilePicture = profilePicture
        setupView()
    }
    func setupView() {
        stateChanged?(.success(viewData))
    }
    private func configureProperty() {
        let user = userService.getUser()
        self.name = user.name
        self.surname = user.surname
        self.gender = user.gender
        self.dateOfBirth = user.dateOfBirth
        if let profileUrlString = UserDefaults.standard.string(forKey: "userProfilePicture") {
            self.profilePicture = cachedImage(stringUrl: profileUrlString) ?? defaultProfilePicture
        } else {
            guard let profileUrlString = user.profilePictureUrl else { return }
            self.profilePicture = cachedImage(stringUrl: profileUrlString) ?? defaultProfilePicture
        }
    }
    private func updateUserFromProperty(with url: String?) {
        let user = userService.getUser()
        user.name = name
        user.surname = surname
        user.gender = gender
        user.updateDate = Date()
        user.dateOfBirth = dateOfBirth
        user.profilePictureUrl = url
        userService.set(user: user)
    }
    func showImagePicker () {
        
    }
    private func cachedImage(stringUrl: String) -> UIImage? {
        var image: UIImage? = nil
        guard let url = URL(string: stringUrl) else { return nil }
        SDWebImageManager.shared.loadImage(with: url, progress: nil) { [weak self] cachedImage, _, _, _, _, _ in
            image = cachedImage
            if cachedImage != nil {
                self?.profilePicture = cachedImage
            }
            guard let self else { self?.exit(with: AppError.incorrectLogicApp); return }
            self.stateChanged?(.success(self.viewData))
        }
        return image
    }
    private func uploadImage(image: UIImage, fileName: String, completion: @escaping (Result<String, Error>)-> Void) {
        guard let imageData = image.jpegData(compressionQuality: 100) else { return }
        firestore.uploadProfilePicture(with: imageData, fileName: fileName) { result in
            completion(result)
        }
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}
