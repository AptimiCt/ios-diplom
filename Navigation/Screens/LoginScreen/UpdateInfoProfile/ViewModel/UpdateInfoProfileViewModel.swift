//
//
// UpdateInfoProfileViewModel.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

enum ScreenType {
    case new
    case update
}
final class UpdateInfoProfileViewModel: UpdateInfoProfileVidewModelProtocol {
    
    //var finishFlow: ((User?) -> Void)?
    weak var coordinator: LoginCoordinator?
    var user: User {
        didSet {
            stateChanged?(.success(viewData))
        }
    }
    
    var stateChanged: ((StateModelProfile) -> Void)?
    
    var viewData: StateModelProfile.UserData {
        StateModelProfile.UserData(name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth, profilePicture: profilePicture)
    }
    
    private var name: String = ""
    private var surname: String = ""
    private var gender: String = ""
    private var dateOfBirth: Date = Date()
    private var profilePicture: String = "avatar"//"defaultProfilePicture"
    
    init(user: User) {
        self.user = user
    }
    
    func updateUser() {
        user.name = name
        user.surname = surname
        user.gender = gender
        user.updateDate = Date()
        user.dateOfBirth = dateOfBirth
        user.avatar = profilePicture
        coordinator?.finishFlow?(user)
    }
    
    func fullName() -> String {
        user.fullName
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
}
