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
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let controller = ControllerFactory(navigationController: navigationController).makeLoginController(with: self)
        guard let controller = controller.toPresent() else { return }
        navigationController.setViewControllers([controller], animated: false)
    }
}
