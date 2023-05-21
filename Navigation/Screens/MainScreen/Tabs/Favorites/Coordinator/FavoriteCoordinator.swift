//
//
// FavoriteCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    

final class FavoriteCoordinator: BaseCoordinator {
    
    private let router: Router
    private var factory: FavoriteControllerFactoryProtocol
    
    init(router: Router, factory: FavoriteControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
        print("FavoriteCoordinator создан")
    }
    
    override func start() {
        let controller = factory.makeFavoriteController()
        router.setRootModule(controller)
    }
    deinit {
        print("FavoriteCoordinator удален")
    }
}
