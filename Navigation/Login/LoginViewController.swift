//
//  LoginViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 16.01.2022.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    //MARK: - property
    private var viewModel: LoginViewModelProtocol
    private var coordinator: LoginCoordinator!
    //private var delegate: LoginViewControllerDelegate?
    private var loginView: LoginView!
    
    //MARK: - init
    init(
        loginView: LoginView,
        viewModel: LoginViewModel,
        coordinator: LoginCoordinator
        //delegate: LoginViewControllerDelegate
    ) {
        self.loginView = loginView
        self.viewModel = viewModel
        self.coordinator = coordinator
        //self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
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
        switchStateViewModel()
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
private extension LoginViewController {
    func switchStateViewModel() {
        viewModel.stateChanged = { [weak self] viewModel in
            guard let self else { return }
            switch viewModel.stateModel {
                case .initial:
                    self.loginView.stateView = .initial
                case .loading:
                    self.loginView.stateView = .loading
                case .success(let authModel):
                    self.loginView.stateView = .success
                    self.showProfile(authModel)
                case .failure(error: let error):
                    self.loginView.stateView = .failure
                    self.handle(with: error)
            }
        }
    }
    //Метод отвечатет за повявление alert при появлении ошибки
    func handle(with error: AuthenticationError) {
        switch error {
            case .incorrectCredentials:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .emptyEmail:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .emptyPassword:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .invalidEmail:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .userNotFound:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .userDisabled:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .loginInUse:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .weakPassword(_):
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .networkError:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .tooManyRequests:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
//            case .configError:
//                coordinator.showAlertController(in: self, message: error.localizedDescription)
            case .unknown:
                coordinator.showAlertController(in: self, message: error.localizedDescription)
        }
    }
    //Открытие Profile View Controller
    func showProfile(_ authModel: AuthModel) {
        let fullName = authModel.name
        self.coordinator.showProfileVC(loginName: fullName)
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
    //Обработка нажатия на кнопку вход
    func login(email: String, password: String) {
        viewModel.checkCredentionalsToLogin(email: email, password: password)
    }
    //Обработка нажатия на кнопку регистрации
    func signUp(email: String, password: String) {
        viewModel.checkCredentionalsForRegistration(email: email, password: password)
    }
    //Обработка нажатия на кнопку входа по биометрии в делегате
//    func loginWithBiometrics() {
//        self.biometricService.authorizeIfPossible { [weak self] sucsses, error  in
//            guard let self else { return }
//            let userService = self.userServiceScheme()
//            let authModel = AuthModel(name: Constants.currentUserServiceFullName, uid: UUID().uuidString)
//            if sucsses {
//                self.showProfile(authModel, userService)
//            } else {
//                guard let error else { return }
//                self.coordinator.showAlertController(in: self, message: error.localizedDescription)
//            }
//        }
//    }
}
