//
//
// FavoriteCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//


final class FavoriteCoordinator: BaseCoordinator {
    
    private let router: Router
    private var factory: ControllersFactoryProtocol
    
    init(router: Router, factory: ControllersFactoryProtocol    ) {
        self.router = router
        self.factory = factory
        super.init()
        Logger.standard.start(on: self)
    }
    
    override func start() {
        let controller = factory.makeFavoriteController(with: self)
        router.setRootModule(controller)
    }
    func showDetail(post: Post, index: Int) {
        let controller = factory.makePostDetailController(post: post, index: index)
        router.push(controller, hideBottomBar: true, hideBar: false)
    }
    deinit {
        Logger.standard.remove(on: self)
    }
}
