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
    
    func runInfoProfileController(authModel: AuthModel) {
        let controller = ControllerFactory(navigationController: navigationController).makeUpdateInfoProfile(user: User(authModel: authModel), coordinator: self)
        guard let controller = controller.toPresent() else { return }
        navigationController.present(controller, animated: true)
    }
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let controller = ControllerFactory(navigationController: navigationController).makeLoginController(with: self)
        guard let controller = controller.toPresent() else { return }
        navigationController.setViewControllers([controller], animated: false)
    }
}
