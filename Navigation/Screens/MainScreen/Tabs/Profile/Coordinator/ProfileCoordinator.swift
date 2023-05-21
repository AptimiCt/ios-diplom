//
//
// ProfileCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//

final class ProfileCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    
    private let router: Router
    private var factory: ProfileControllerFactoryProtocol
    
    init(router: Router ,factory: ProfileControllerFactoryProtocol) {
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
    deinit {
        print("ProfileCoordinator удален")
    }
}

private extension ProfileCoordinator {
    func runProfile() {
        let controller = factory.makeProfileController(coordinator: self)
        router.setRootModule(controller, hideBar: true)
    }
}
