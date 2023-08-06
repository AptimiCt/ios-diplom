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
        super.init()
        Logger.standard.start(on: self)
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
    func showEditProfileVC(){
            let coordinator = UpdateInfoProfileCoordinator(router: router, factory: factory)
            coordinator.screenType = .update
            coordinator.finishFlow = { [weak self, weak coordinator] user, error in
                self?.router.dismissModule()
                if let error {
                    self?.showAlert(inputData: UIAlertControllerInputData(message: error.localizedDescription, buttons: [.init(title: "ОК")]))
                }
                NotificationCenter.default.post(name: Notification.Name(Constants.notifyForUpdateProfile), object: nil)
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

private extension ProfileCoordinator {
    func runProfile() {
        let controller = factory.makeProfileController(with: self)
        router.setRootModule(controller, hideBar: true)
    }
}
