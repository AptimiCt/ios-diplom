//
//
// ProfileCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit

final class ProfileCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    
    private let user: User
    private var factory: ProfileControllerFactoryProtocol
    
    init(user: User, navigationController: UINavigationController) {
        self.user = user
        self.factory = ControllerFactory(navigationController: navigationController)
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        runProfile()
    }
    func showPhotosVC(){
        let controller = factory.makePhotosController()
        guard let controller = controller.toPresent() else { return }
        navigationController.pushViewController(controller, animated: true)
        navigationController.isNavigationBarHidden = false
    }
}

private extension ProfileCoordinator {
    func runProfile() {
        let controller = factory.makeProfileController(with: user, and: self)
        guard let controller = controller.toPresent() else { return }
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([controller], animated: false)
    }
}
