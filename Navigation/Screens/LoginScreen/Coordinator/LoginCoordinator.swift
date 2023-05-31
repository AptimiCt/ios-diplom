//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Александр Востриков on 22.07.2022.
//

import UIKit

class LoginCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    private let router: Router
    private let factory: AuthControllerFactoryProtocol
    
    init(router: Router, factory: AuthControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
        print("LoginCoordinator создан")
    }
    
    override func start() {
        loginViewConfigure()
    }
    
    func runInfoProfileController(screenType: ScreenType) {
        let controller = factory.makeUpdateInfoProfile(with: self, screenType: screenType)
        router.present(controller)
    }
    func showAlert(inputData: UIAlertControllerInputData) {
        let alert = UIAlertController(inputData: inputData)
        router.present(alert)
    }
    deinit {
        print("LoginCoordinator удален")
    }
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let controller = factory.makeLoginController(with: self)
        router.setRootModule(controller, hideBar: true)
    }
}
