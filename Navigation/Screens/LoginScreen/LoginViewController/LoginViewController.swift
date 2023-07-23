//
//  LoginViewController.swift
//  Navigation
//
//  Created by Александр Востриков on 16.01.2022.
//

import UIKit

class LoginViewController: UIViewController, LoginViewControllerProtocol {
    
    //MARK: - property
    internal var viewModel: LoginViewModelProtocol
    internal var loginView: LoginView!
    
    //MARK: - init
    init(loginView: LoginView, viewModel: LoginViewModel) {
        self.loginView = loginView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        Logger.standart.start(on: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override funcs
    override func loadView() {
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
    deinit {
        Logger.standart.remove(on: self)
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
                case .success:
                    self.loginView.stateView = .success
                case .failure:
                    self.loginView.stateView = .failure
            }
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
    //Обработка нажатия на кнопку вход
    func login(email: String, password: String) {
        viewModel.checkCredentionalsToLogin(email: email, password: password)
    }
    //Обработка нажатия на кнопку регистрации
    func signUp(email: String, password: String) {
        viewModel.checkCredentionalsForRegistration(email: email, password: password)
    }
    //Обработка нажатия на кнопку входа по биометрии в делегате
    func loginWithBiometrics() {
        viewModel.loginWithBiometrics()
    }
}
