//
//
// UpdateInfoProfileCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

class UpdateInfoProfileCoordinator: BaseCoordinator {
    
    var finishFlow: OptionalUserAndErrorClosure?
    
    var screenType: ScreenType! = .new
    
    private let router: Router
    private let factory: UpdateInfoProfileControllerFactoryProtocol
    
    init(router: Router, factory: UpdateInfoProfileControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
        super.init()
        Logger.standard.start(on: self)
    }
    
    override func start() {
        runInfoProfileController(screenType: screenType)
    }

    deinit {
        Logger.standard.remove(on: self)
    }
}

private extension UpdateInfoProfileCoordinator {
    func runInfoProfileController(screenType: ScreenType) {
        let controller = factory.makeUpdateInfoProfile(with: self, screenType: screenType)
        router.present(controller)
    }
}
