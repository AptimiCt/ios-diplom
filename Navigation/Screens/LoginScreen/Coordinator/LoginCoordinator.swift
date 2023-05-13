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
    private let router: Router
    private let factory: AuthControllerFactoryProtocol
    
    init(router: Router, factory: AuthControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        loginViewConfigure()
    }
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let controller = factory.makeLoginController(with: self)
        router.setRootModule(controller, hideBar: true)
    }
}
