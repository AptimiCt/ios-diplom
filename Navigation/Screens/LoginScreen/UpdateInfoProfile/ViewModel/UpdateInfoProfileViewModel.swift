//
//
// UpdateInfoProfileViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class UpdateInfoProfileViewModel: UpdateInfoProfileVidewModelProtocol {
    
    weak var coordinator: LoginCoordinator?
    private let userService: UserService
    private let firestore: DatabeseManagerProtocol
    
    var stateChanged: ((StateModelProfile) -> Void)?
    
    var viewData: StateModelProfile.UserData {
        StateModelProfile.UserData(name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth, profilePicture: profilePicture)
    }
    
    private var name: String = ""
    private var surname: String = ""
    private var gender: String = ""
    private var dateOfBirth: Date = Date()
    private var profilePicture: String = "defaultProfilePicture"
    
    init(userService: UserService, firestore: DatabeseManagerProtocol) {
        self.userService = userService
        self.firestore = firestore
        self.configureProperty()
    }
    
    func updateUser() {
        updateUserFromProperty()
        firestore.updateUser(user: userService.getUser()) { [weak self] error in
            self?.coordinator?.showAlert(inputData: UIAlertControllerInputData(message: error?.localizedDescription, buttons: [.init(title: "ОК")]))
            self?.coordinator?.finishFlow?(self?.userService.getUser())
        }
    }
    func addUser() {
        updateUserFromProperty()
        firestore.addUser(user: userService.getUser()) { [weak self] error in
            self?.coordinator?.showAlert(inputData: UIAlertControllerInputData(message: error?.localizedDescription, buttons: [.init(title: "ОК")]))
            self?.coordinator?.finishFlow?(self?.userService.getUser())
        }
    }
    
    func fullName() -> String {
        userService.getUser().getFullName()
    }
    
    func updateName(_ name: String) {
        self.name = name
    }
    
    func updateSurname(_ surname: String) {
        self.surname = surname
    }
    
    func updateGender(_ gender: String) {
        self.gender = gender
    }
    
    func updateDateOfBirth(_ dateOfBirth: Date) {
        self.dateOfBirth = dateOfBirth
    }
    
    func updateProfilePicture(_ profilePicture: String) {
        self.profilePicture = profilePicture
    }
    func setupView() {
        stateChanged?(.success(viewData))
    }
    private func configureProperty() {
        self.name = userService.getUser().name
        self.surname = userService.getUser().surname
    }
    private func updateUserFromProperty() {
        let user = userService.getUser()
        user.name = name
        user.surname = surname
        user.gender = gender
        user.updateDate = Date()
        user.dateOfBirth = dateOfBirth
        user.avatar = profilePicture
        userService.set(user: user)
    }
}
