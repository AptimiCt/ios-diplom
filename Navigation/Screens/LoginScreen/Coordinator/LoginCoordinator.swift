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
    private let factory: ControllersFactoryProtocol
    
    init(router: Router, factory: ControllersFactoryProtocol) {
        self.router = router
        self.factory = factory
        super.init()
        Logger.standard.start(on: self)
    }
    
    override func start() {
        loginViewConfigure()
    }
    
    func runInfoProfileController(screenType: ScreenType) {
        let coordinator = UpdateInfoProfileCoordinator(router: router, factory: factory)
        coordinator.finishFlow = { [weak self, weak coordinator] user, error in
            self?.router.dismissModule()
            if let error {
                self?.showAlert(inputData: UIAlertControllerInputData(message: error.localizedDescription, buttons: [.init(title: "UIAC.ok".localized)]))
                self?.loginViewConfigure()
            } else {
                self?.finishFlow?(user)
            }
            self?.removeCoordinator(coordinator)
        }
        addCoordinator(coordinator)
        coordinator.start()
    }
    func showAlert(inputData: UIAlertControllerInputData) {
        let alert = UIAlertController(inputData: inputData)
        router.present(alert)
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}

private extension LoginCoordinator {
    func loginViewConfigure() {
        let controller = factory.makeLoginController(with: self)
        router.setRootModule(controller, hideBar: true)
    }
}
