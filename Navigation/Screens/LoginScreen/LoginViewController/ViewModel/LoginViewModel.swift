//
//
// LoginViewModel.swift
// Navigation
//
// Created by Александр Востриков
//

import FirebaseAuth
import UIKit

final class LoginViewModel: LoginViewModelProtocol {
    
    var userService: UserService?
    private let firestore: DatabeseManagerProtocol
    weak var coordinator: LoginCoordinator!
    var stateModel: StateModel = .initial {
        didSet {
            self.stateChanged?(self)
        }
    }
    var stateChanged: ((LoginViewModelProtocol) -> Void)?
    
    init(firestore: DatabeseManagerProtocol){
        self.firestore = firestore
    }
    func checkCredentionalsToLogin(email: String, password: String) {
        do {
            try checkCredentionalsOnError(email: email, password: password)
            CheckerService.shared.checkCredentialsService(email: email, password: password) { [weak self] authDataResult, error in
                self?.handler(authDataResult: authDataResult, and: error, for: .login)
            }
        } catch {
            self.handle(with: error as! AuthenticationError)
        }
    }
    func checkCredentionalsForRegistration(email: String, password: String) {
        do {
            try checkCredentionalsOnError(email: email, password: password)
            CheckerService.shared.signUpService(email: email, password: password) { [weak self] authDataResult, error in
                self?.handler(authDataResult: authDataResult, and: error, for: .registration)
            }
        } catch {
            self.handle(with: error as! AuthenticationError)
            
        }
    }
    func loginWithBiometrics() {
        LocalAuthorizationService().authorizeIfPossible { [weak self] sucsses, error  in
            guard let self else { return }
            if sucsses {
                self.finishFlow(User())
            } else {
                self.handle(with: .unknown(""))
            }
        }
    }
}

private extension LoginViewModel {
    func handler(authDataResult: AuthDataResult?, and error: AuthenticationError?, for buttonType: ButtonsTapped) {
        if let error = error {
            self.handle(with: error)
            return
        }
        guard let authDataResult else {
            self.handle(with: .unknown("authDataResult nil"))
            return
        }
        let uid = authDataResult.user.uid
        if userService?.user == nil {
            let name = authDataResult.user.displayName
            let email = authDataResult.user.email
            let user = User(uid: uid, email: email, name: name ?? email ?? Constants.currentUserServiceFullName)
            userService?.set(user: user)
        }
        switch buttonType {
            case .login:
                self.fetchUser(for: uid)
            case .registration:
                self.coordinator.runInfoProfileController(screenType: .new)
            default:
                break
        }
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
    //Метод отвечатет за повявление alert при появлении ошибки
    func handle(with error: AuthenticationError) {
        self.stateModel = .failure(error)
        let inputData = UIAlertControllerInputData(message: error.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)])
        switch error {
            case .incorrectCredentials:
                coordinator.showAlert(inputData: inputData)
            case .emptyEmail:
                coordinator.showAlert(inputData: inputData)
            case .emptyPassword:
                coordinator.showAlert(inputData: inputData)
            case .invalidEmail:
                coordinator.showAlert(inputData: inputData)
            case .userNotFound:
                coordinator.showAlert(inputData: inputData)
            case .userDisabled:
                coordinator.showAlert(inputData: inputData)
            case .loginInUse:
                coordinator.showAlert(inputData: inputData)
            case .weakPassword(_):
                coordinator.showAlert(inputData: inputData)
            case .networkError:
                coordinator.showAlert(inputData: inputData)
            case .tooManyRequests:
                coordinator.showAlert(inputData: inputData)
            case .unknown:
                coordinator.showAlert(inputData: inputData)
        }
    }
    //Переход в основной поток
    func finishFlow(_ user: User) {
        self.stateModel = .success
        self.coordinator.finishFlow?(user)
    }
    func fetchUser(for uid: String) {
        self.firestore.fetchUser(uid: uid) { [weak self, weak coordinator] result in
            switch result {
                case .success(let user):
                    self?.finishFlow(user)
                case .failure(let error):
                    print("error LoginViewModel:\(error)")
                    self?.stateModel = .failure(AuthenticationError.unknown(error.localizedDescription))
                    let inputData = UIAlertControllerInputData(message: error.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)])
                    coordinator?.showAlert(inputData: inputData)
            }
        }
    }
}
