//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import Foundation
import UIKit
import StorageService

class LoginCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    
    override func start() {
        loginViewConfigure()
    }
    func showAlertController(message: String) {
        var presentingController: UIViewController
        if let presentedController = self.navigationController.visibleViewController {
            presentingController = presentedController
        } else {
            presentingController = self.navigationController
        }
        AlertController.defaultController.showAlert(in: presentingController, message: message)
    }
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let biometricService = LocalAuthorizationService()
        let loginView = LoginView(biometricType: biometricService.biometricType)
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(loginView: loginView, viewModel: loginViewModel)
        loginView.delegate = loginViewController
        loginViewModel.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.tabBarItem = UITabBarItem(title: Constants.tabBarItemLoginVCTitle,
                                                   image: UIImage(systemName: "person.crop.circle.fill"),
                                                   tag: 1)
        navigationController.setViewControllers([loginViewController], animated: true)
    }
    //    Выбора UserService в зависимости от схемы
    func userServiceScheme() -> UserService {
        #if DEBUG
        let userService = TestUserService()
        #else
        let userService = CurrentUserService()
        #endif
        return userService
    }
}
