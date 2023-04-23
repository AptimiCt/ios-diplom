//
//
// LoginViewModel.swift
// Navigation
//
// Created by Александр Востриков
//


import Foundation
import Firebase

protocol LoginViewModelProtocol {
    
    var stateModel: StateModel { get set }
    var stateChanged: ((LoginViewModelProtocol) -> Void)? { get set }
    func checkCredentionalsToLogin(email: String, password: String)
    func checkCredentionalsForRegistration(email: String, password: String)
}


final class LoginViewModel: LoginViewModelProtocol {
    
    private var profile = Profile()
    var stateModel: StateModel = .initial {
        didSet {
            self.stateChanged?(self)
        }
    }
    var stateChanged: ((LoginViewModelProtocol) -> Void)?
    
    func checkCredentionalsToLogin(email: String, password: String) {
        do {
            try checkCredentionalsOnError(email: email, password: password)
            CheckerService.shared.checkCredentialsService(email: email, password: password) { [weak self] authDataResult, error in
                self?.handler(authDataResult: authDataResult, and: error)
            }
        } catch {
            stateModel = .failure(error: error as! AuthenticationError)
        }
    }
    func checkCredentionalsForRegistration(email: String, password: String) {
        do {
            try checkCredentionalsOnError(email: email, password: password)
            CheckerService.shared.signUpService(email: email, password: password) { [weak self] authDataResult, error in
                self?.handler(authDataResult: authDataResult, and: error)
            }
        } catch {
            stateModel = .failure(error: error as! AuthenticationError)
        }
    }
}

private extension LoginViewModel {
    func handler(authDataResult: AuthDataResult?, and error: AuthenticationError?) {
        if let error = error {
            self.stateModel = .failure(error: error)
            return
        }
        guard let authDataResult else {
            self.stateModel = .failure(error: .unknown)
            return
        }
        let name = Constants.currentUserServiceFullName
        let uid = authDataResult.user.uid
        let authModel = AuthModel(name: name, uid: uid)
        self.profile.update(with: authModel)
        self.stateModel = .success(authModel)
    }
    //Медод проверки учетных данных на корректность который может выбрасывать ошибки
    func checkCredentionalsOnError(email: String, password: String) throws {
        if email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            throw AuthenticationError.emptyEmail
        } else if !validate(email) {
            throw AuthenticationError.invalidEmail
        }
        if password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            throw AuthenticationError.emptyPassword
        }
        if !passwordIsValid(password) {
            throw AuthenticationError.weakPassword("weakPasswordExtend".localized)
        }
    }
    //Метод для локальной проверки пароля на соответсие требованиям(от 8 символов, большие и маленькие буквы и символы)
    func passwordIsValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    //Метод для локальной проверки Email на корректность
    func validate(_ email: String) -> Bool {
        let emailRegEx = "([a-z0-9.]){1,64}@([a-z0-9]){1,64}\\.([a-z0-9]){2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
