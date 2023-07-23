//
//
// TabBarCoordinator.swift
// Navigation
//
// Created by Александр Востриков
//


import UIKit

final class MainCoordinator: BaseCoordinator, OutputCoordinator {
    
    var finishFlow: ((User?) -> Void)?
    
    private let router: Router
    private var userService: UserService
    private var tabBarController: TabBarController
    private var factory: ControllersFactoryProtocol
    
    init(
        router: Router,
        tabBarVC: TabBarController,
        userService: UserService,
        factory: ControllersFactoryProtocol
    ) {
        self.tabBarController = tabBarVC
        self.router = router
        self.userService = userService
        self.factory = factory
        super.init()
        Logger.standart.start(on: self)
    }
    override func start() {
        tabBarController.onFeedSelect = runFeedSelect()
        tabBarController.onProfileSelect = runProfileSelect()
        tabBarController.onFavoriteSelect = runFavoriteSelect()
        tabBarController.firstLoad()
    }
    deinit {
        Logger.standart.remove(on: self)
    }
}

private extension MainCoordinator {
    
    func runFeedSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let router = RouterImpl(rootController: navController)
                let feedCoordinator = FeedCoordinator(router: router, factory: factory)
                self.addCoordinator(feedCoordinator)
                feedCoordinator.start()
            }
        }
    }
    func runProfileSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let router = RouterImpl(rootController: navController)
                let profileCoordinator = ProfileCoordinator(router: router, factory: factory)
                profileCoordinator.finishFlow = { [weak self, weak profileCoordinator] user in
                    if user == nil {
                        self?.userService.friends = []
                        self?.userService.set(user: nil)
                    }
                    self?.removeCoordinator(profileCoordinator)
                    self?.finishFlow?(user)
                }
                addCoordinator(profileCoordinator)
                profileCoordinator.start()
            }
        }
    }
    func runFavoriteSelect() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let router = RouterImpl(rootController: navController)
                let favoriteCoordinator = FavoriteCoordinator(router: router, factory: factory)
                addCoordinator(favoriteCoordinator)
                favoriteCoordinator.start()
            }
        }
    }
}
