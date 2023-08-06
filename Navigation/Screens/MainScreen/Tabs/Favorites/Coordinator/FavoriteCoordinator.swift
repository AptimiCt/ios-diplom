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
        super.init()
        Logger.standard.start(on: self)
    }
    
    override func start() {
        let controller = factory.makeFavoriteController()
        router.setRootModule(controller)
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}
