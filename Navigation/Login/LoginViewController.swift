//
//  LoginViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 16.01.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - vars
    private var coordinator: LoginCoordinator
    private var delegate: LoginViewControllerDelegate?
    private let biometricService = LocalAuthorizationService()
    private lazy var loginView: LoginView = LoginView(
                                                biometricType: biometricService.biometricType,
                                                delegate: self)
    private let tabBarItemLocal = UITabBarItem(title: Constants.tabBarItemLoginVCTitle,
                                               image: UIImage(systemName: "person.crop.circle.fill"),
                                               tag: 1)
    
    //MARK: - init
    init(coordinator: LoginCoordinator, delegate: LoginViewControllerDelegate){
        self.coordinator = coordinator
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = tabBarItemLocal
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func loadView() {
        super.loadView()
        view = loginView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginView.activityIndicatorOff()
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
private extension LoginViewController {
    //Метод отвечатет за повявление alert при появлении ошибки в интерфейсе
    func handle(error: CredentialError) {
        switch error {
            case .incorrectCredentials:
                coordinator.showAlertController(in: self, message: ~error.rawValue)
            case .emptyEmail:
                coordinator.showAlertController(in: self, message: ~error.rawValue)
            case .emptyPassword:
                coordinator.showAlertController(in: self, message: ~error.rawValue)
            case .emailIsNoCorrect:
                coordinator.showAlertController(in: self, message: ~error.rawValue)
            case .unknown:
                coordinator.showAlertController(in: self, message: ~error.rawValue)
        }
    }
    //Метод отвечатет за повявление alert при появлении ошибки от firebase
    func switchFailure(_ failure: NSError) {
        switch failure.userInfo["FIRAuthErrorUserInfoNameKey"] as? String {
            case FirebaseResponseError.ERROR_INVALID_EMAIL.rawValue:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.invalidEmail.rawValue)
            case FirebaseResponseError.ERROR_USER_NOT_FOUND.rawValue:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.registerUser.rawValue)
            case FirebaseResponseError.ERROR_WRONG_PASSWORD.rawValue:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.wrongPassword.rawValue)
            case FirebaseResponseError.ERROR_NETWORK_REQUEST_FAILED.rawValue:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.internetConnectionProblem.rawValue)
            case FirebaseResponseError.ERROR_EMAIL_ALREADY_IN_USE.rawValue:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.theUserWithThisEmailAlreadyExists.rawValue)
            case FirebaseResponseError.ERROR_TOO_MANY_REQUESTS.rawValue:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.tooManyRequests.rawValue)
            default:
                coordinator.showAlertController(in: self, message: ~FirebaseResponseErrorMessage.unknownError.rawValue)
        }
    }
    //Открытие Profile View Controller
    func showProfile(_ authModel: AuthModel, _ userService: UserService) {
        let fullName = authModel.name
        self.coordinator.showProfileVC(loginName: fullName, userService: userService)
    }
    //Выбора UserService в зависимости от схемы
    func userServiceScheme() -> UserService {
        #if DEBUG
        let userService = TestUserService()
        #else
        let userService = CurrentUserService()
        #endif
        return userService
    }
    //Обработка результата completion
    func switchResult(_ result: Result<AuthModel, NSError>, completion: @escaping () -> Void) {
        let userService = self.userServiceScheme()
        switch result {
            case .success(let authModel):
                self.showProfile(authModel, userService)
                completion()
            case .failure(let failure):
                self.switchFailure(failure)
                completion()
        }
    }
}
//MARK: - @objc private funcs in extension
@objc private extension LoginViewController {
    //Метод выполняются когда появляется клавиатура
    func keyboardWillShow(notification: NSNotification){
        loginView.keyboardWillShow(notification: notification)
    }
    //Метод выполняются когда скрывается клавиатура
    func keyboardWillHide(notification: NSNotification){
        loginView.keyboardWillHide(notification: notification)
    }
}
//MARK: - extension LoginViewController: LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    //Обработка нажатия на кнопку вход в делегате
    func login(email: String, password: String, completion: @escaping () -> Void) {
        delegate?.checkCredentionalsInspector(email: email, password: password, completion: { [weak self] result in
            self?.switchResult(result, completion: completion)
        })
    }
    //Обработка нажатия на кнопку регистрации в делегате
    func signUp(email: String, password: String, completion: @escaping () -> Void) {
        self.delegate?.signUpInspector(email: email, password: password, completion: { [weak self] result in
            self?.switchResult(result, completion: completion)
        })
    }
    //Обработка нажатия на кнопку входа по биометрии в делегате
    func loginWithBiometrics() {
        self.biometricService.authorizeIfPossible { [weak self] sucsses, error  in
            guard let self else { return }
            let userService = self.userServiceScheme()
            let authModel = AuthModel(name: Constants.currentUserServiceFullName, uid: UUID().uuidString)
            if sucsses {
                self.showProfile(authModel, userService)
            } else {
                guard let error else { return }
                self.coordinator.showAlertController(in: self, message: error.localizedDescription)
            }
        }
    }
    //Показ ошибки если локальная проверка данных прошла не успешно
    func buttonTapped(with error: Error) {
        handle(error: error as? CredentialError ?? .unknown)
    }
}
