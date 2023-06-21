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
//        let controller = factory.makePhotosController()
//        router.push(controller, hideBottomBar: true, hideBar: false)
        
        let controller = factory.makeUpdateInfoProfile(with: LoginCoordinator(router: router, factory: factory), screenType: .update)
        router.present(controller)

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
