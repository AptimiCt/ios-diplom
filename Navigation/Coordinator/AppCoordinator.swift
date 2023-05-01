//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 19.06.2022.
//

import Foundation
import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private var isAutorized = false
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure(isAutorized: isAutorized)
    }
    
    var rootController: UINavigationController?
    let localNotificationService = LocalNotificationsService()
    
    init(rootController: UINavigationController?) {
        self.rootController = rootController
    }
    
    override func start() {
        switch instructor {
            case .auth:
                runAuthFlow()
            case .main:
                runMainFlow()
        }
    }
}

private extension AppCoordinator {
    func runAuthFlow() {
        loginViewConfigure()
    }
    func runMainFlow() {
        let tabBarVC = ControllersFactory.createTabBarController()
        rootController?.setViewControllers([tabBarVC], animated: true)
    }
    
    func loginViewConfigure() {
        guard let rootController else { return }
        let loginCoordinator = LoginCoordinator(navController: rootController)
        let biometricService = LocalAuthorizationService()
        let loginView = LoginView(
            biometricType: biometricService.biometricType)
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(
                                                      loginView: loginView,
                                                      viewModel: loginViewModel,
                                                      coordinator: loginCoordinator
        )
        loginView.delegate = loginViewController
        rootController.navigationBar.isHidden = true
        rootController.tabBarItem = UITabBarItem(title: Constants.tabBarItemLoginVCTitle,
                                                   image: UIImage(systemName: "person.crop.circle.fill"),
                                                   tag: 1)
        rootController.setViewControllers([loginViewController], animated: true)
    }
    func appConfiguration() {
        let appConfiguration = AppConfiguration.allCases.randomElement()
        NetworkManager.request(for: appConfiguration)
    }
    func localNotificationRegister() {
        localNotificationService.registeForLatestUpdatesIfPossible()
    }
}
