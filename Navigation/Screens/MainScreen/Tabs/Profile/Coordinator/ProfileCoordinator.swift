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
    private let user: User
    private var factory: ProfileControllerFactoryProtocol
    
    init(user: User, router: Router ,factory: ProfileControllerFactoryProtocol) {
        self.user = user
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        runProfile()
    }
    func showPhotosVC(){
        let controller = factory.makePhotosController()
        router.push(controller, hideBottomBar: true, hideBar: false)
    }
}

private extension ProfileCoordinator {
    func runProfile() {
        let controller = factory.makeProfileController(with: user, and: self)
        router.setRootModule(controller, hideBar: true)
    }
}
