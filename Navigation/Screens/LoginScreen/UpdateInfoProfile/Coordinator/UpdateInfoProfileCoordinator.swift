//
//
// UpdateInfoProfileCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//
    
import UIKit

class UpdateInfoProfileCoordinator: BaseCoordinator {
    
    var finishFlow: OptionalErrorClosure?
    
    var screenType: ScreenType! = .new
    
    private let router: Router
    private let factory: UpdateInfoProfileControllerFactoryProtocol
    
    init(router: Router, factory: UpdateInfoProfileControllerFactoryProtocol) {
        self.router = router
        self.factory = factory
        print("UpdateInfoProfileCoordinator создан")
    }
    
    override func start() {
        runInfoProfileController(screenType: screenType)
    }

    deinit {
        print("UpdateInfoProfileCoordinator удален")
    }
}

private extension UpdateInfoProfileCoordinator {
    func runInfoProfileController(screenType: ScreenType) {
        let controller = factory.makeUpdateInfoProfile(with: self, screenType: screenType)
        router.present(controller)
    }
}
