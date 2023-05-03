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
    private var user: User?
    
    let localNotificationService = LocalNotificationsService()
    
    override func start() {
        switch instructor {
            case .auth: runAuthFlow()
            case .main: runMainFlow()
        }
    }
}

private extension AppCoordinator {
    func runAuthFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.finishFlow = { [weak self, weak loginCoordinator] user in
            if user != nil {
                self?.isAutorized = true
                self?.user = user
            }
            self?.start()
            self?.removeCoordinator(loginCoordinator)
        }
        addCoordinator(loginCoordinator)
        loginCoordinator.start()
    }
    func runMainFlow() {
        let tabBarVC = ControllersFactory.createTabBarController()
        navigationController.setViewControllers([tabBarVC], animated: true)
    }
    func appConfiguration() {
        let appConfiguration = AppConfiguration.allCases.randomElement()
        NetworkManager.request(for: appConfiguration)
    }
    func localNotificationRegister() {
        localNotificationService.registeForLatestUpdatesIfPossible()
    }
}
