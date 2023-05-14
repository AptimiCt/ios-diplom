//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import UIKit
//import StorageService

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
    
    func runInfoProfileController(authModel: AuthModel) {
        let controller = factory.makeUpdateInfoProfile(user: User(authModel: authModel), coordinator: self)
        router.present(controller)
    }
    func showAlert(inputData: UIAlertControllerInputData) {
        let alert = UIAlertController(inputData: inputData)
        router.present(alert)
    }
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let controller = factory.makeLoginController(with: self)
        router.setRootModule(controller, hideBar: true)
    }
}
