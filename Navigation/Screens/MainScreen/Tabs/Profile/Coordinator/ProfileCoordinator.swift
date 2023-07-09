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
    
    private let router: Router
    private var factory: ControllersFactoryProtocol
    
    init(router: Router ,factory: ControllersFactoryProtocol ) {
        self.router = router
        self.factory = factory
        print("ProfileCoordinator создан")
    }
    
    override func start() {
        runProfile()
    }
    func showPhotosVC(){
        let controller = factory.makePhotosController()
        router.push(controller, hideBottomBar: true, hideBar: false)
    }
    func showFindFriendVC(){
        let controller = factory.makeFindFriendController(with: self)
        router.present(controller, hideBar: false)
    }
    func showAlert(inputData: UIAlertControllerInputData) {
        let alert = UIAlertController(inputData: inputData)
        router.present(alert)
    }
    deinit {
        print("ProfileCoordinator удален")
    }
}

private extension ProfileCoordinator {
    func runProfile() {
        let controller = factory.makeProfileController(with: self)
        router.setRootModule(controller, hideBar: true)
    }
}
